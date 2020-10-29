import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickshopping/Admin/adminLogin.dart';
import 'package:quickshopping/Store/storeHome.dart';
import 'package:quickshopping/Widgets/cutomTextfield.dart';
import 'package:quickshopping/DialogBox/errorDialog.dart';
import 'package:quickshopping/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickshopping/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordTextEditingControler =
      TextEditingController();
  final TextEditingController _emailTextEditingControler =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/login.png',
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Login to your account',
                style: TextStyle(color: Colors.white24),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  RaisedButton(
                    onPressed: () {
                      _emailTextEditingControler.text.isNotEmpty &&
                              _passwordTextEditingControler.text.isNotEmpty
                          ? loginUser()
                          : showDialog(
                              context: context,
                              builder: (c) {
                                return ErrorAlertDialog(
                                  message: 'Please write email and Password',
                                );
                              });
                    },
                    color: Colors.blueGrey,
                    child: Text(
                      'Login',
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
                    height: 10.0,
                  ),
                  FlatButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminSignInPage()),
                    ),
                    icon: Icon(
                      Icons.nature_people,
                      color: Colors.redAccent,
                    ),
                    label: Text(
                      'I am an Admin',
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Authenticating, Please wait...',
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingControler.text.trim(),
            password: _passwordTextEditingControler.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null){
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future readData(User fUser) async{
    FirebaseFirestore.instance.collection('users').doc(fUser.uid).get().then((DocumentSnapshot dataSnapshot) async {
   await EcommerceApp.sharedPreferences.setString('uid', dataSnapshot.data()[EcommerceApp.userUID] );

   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapshot.data()[EcommerceApp.userEmail]);

   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot.data()[EcommerceApp.userName]);
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data()[EcommerceApp.userAvatarUrl]);
  
   List<String> cartList = dataSnapshot.data()[EcommerceApp.userCartList].cast<String>();

   await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
