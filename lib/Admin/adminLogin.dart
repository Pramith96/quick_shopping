import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickshopping/Admin/uploadItems.dart';
import 'package:quickshopping/Authentication/authentication.dart';
import 'package:quickshopping/Widgets/cutomTextfield.dart';
import 'package:quickshopping/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.teal, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'Quick Shopping',
          style: TextStyle(
            fontSize: 55.0,
            fontFamily: "Signatra",
            color: Colors.indigo[50],
          ),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _passwordTextEditingControler =
      TextEditingController();
  final TextEditingController _adminIDTextEditingControler =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.teal, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/admin.png',
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.black87, fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingControler,
                    data: Icons.email,
                    hintText: 'ID',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingControler,
                    data: Icons.person,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ], 
              ),
            ),
               SizedBox(
                    height: 25.0,
                  ),
             RaisedButton(
                    onPressed: () {
                      _adminIDTextEditingControler.text.isNotEmpty &&
                              _passwordTextEditingControler.text.isNotEmpty
                          ? loginAdmin()
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
                    height: 20.0,
                  ),
                  FlatButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticScreen()),
                    ),
                    icon: Icon(
                      Icons.nature_people,
                      color: Colors.redAccent,
                    ),
                    label: Text(
                      'I am not an Admin',
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
          
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection('admins').get().then((snapshot){
      snapshot.docs.forEach((result) { 
        if(result.data()['id'] != _adminIDTextEditingControler.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid ID'),));
        }
        else if(result.data()['password'] != _passwordTextEditingControler.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid Pasword'),));
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Welcome dear admin, ' + result.data()['name']),));
          setState(() {
            _adminIDTextEditingControler.text = '';
            _passwordTextEditingControler.text = '';
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        } 
      });
    } );
  }
}
