import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickshopping/Store/storeHome.dart';
import 'package:quickshopping/Widgets/cutomTextfield.dart';
import 'package:quickshopping/DialogBox/errorDialog.dart';
import 'package:quickshopping/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickshopping/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingControler =
      TextEditingController();
  final TextEditingController _emailTextEditingControler =
      TextEditingController();
  final TextEditingController _passwordTextEditingControler =
      TextEditingController();
  final TextEditingController _CPasswordTextEditingControler =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = '';
  File _imageFile;
  String name = '';

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(Icons.add_a_photo,
                        size: _screenWidth * 0.15, color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (val){
                      setState(() => name = val);
                    }
        
                  ),
                  CustomTextField(
                    controller: _emailTextEditingControler,
                    data: Icons.email,
                    hintText: 'email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingControler,
                    data: Icons.lock_outline,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _CPasswordTextEditingControler,
                    data: Icons.lock_outline,
                    hintText: 'Comfirm Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () { uploadAndSaveImage();},
              color: Colors.blueGrey,
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.blueGrey,
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

 Future<void> _selectAndPickImage() async{
  _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
 }

 Future<void> uploadAndSaveImage() async{
   if(_imageFile == null){
     showDialog(
       context: context,
       builder: (c){
         return ErrorAlertDialog(message: 'Please select and image file');
       }
     );
   } else {
     _passwordTextEditingControler.text == _CPasswordTextEditingControler.text ?
      _emailTextEditingControler.text.isNotEmpty && _nameTextEditingControler.text.isNotEmpty && _passwordTextEditingControler.text.isNotEmpty && _CPasswordTextEditingControler.text.isNotEmpty
      ? uploadToStorage()

      :displayDialog('Registation is not complete!!')

      : displayDialog('Password do not match');

   }
 }
 displayDialog(String msg){
   showDialog(
     context: context,
     builder: (c){
       return ErrorAlertDialog(message: msg);
     }
   );
 }
 uploadToStorage() async {
   showDialog(
     context: context,
     builder: (c){
       return LoadingAlertDialog(
         message:'Registering, Please Wait....',
       );
     }
   );
   String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
  //  StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
  firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child(imageFileName);
   //StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
  firebase_storage.UploadTask storageUploadTask = storageReference.putFile(_imageFile);
   //StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
   firebase_storage.TaskSnapshot taskSnapshot = await storageUploadTask;
   await taskSnapshot.ref.getDownloadURL().then((urlImage){
     userImageUrl = urlImage;

     _registerUser();
   });
 }
 FirebaseAuth _auth = FirebaseAuth.instance;
 void _registerUser() async{
   User firebaseUser;
   await _auth.createUserWithEmailAndPassword(
     email: _emailTextEditingControler.text.trim(), 
     password: _passwordTextEditingControler.text.trim()
     ).then((auth) {
       firebaseUser = auth.user;
     }).catchError((error){
       Navigator.pop(context);
       showDialog(
         context: context,
         builder: (c){
           return ErrorAlertDialog(message: error.message.toString(),);
         }
         );
     }

     );
  if (firebaseUser != null){
    saveUserInfoToFireStore(firebaseUser).then((value) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
    });
  }
 }

 Future saveUserInfoToFireStore(User fUser)async{
   FirebaseFirestore.instance.collection('users').doc(fUser.uid).set(
     {
       'uid': fUser.uid,
       'email': fUser.email,
       'name': _nameTextEditingControler.text.trim(),
       'url': userImageUrl,
       EcommerceApp.userCartList: ['garbageValue'],
     }
   );

   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userUID, fUser.uid);
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingControler.text);
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
   await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ['garbageValue']);
 }
}
