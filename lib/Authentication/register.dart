import 'dart:io';
import 'package:quickshopping/Widgets/cutomTextfield.dart';
import 'package:quickshopping/DialogBox/errorDialog.dart';
import 'package:quickshopping/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
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
  final TextEditingController _CPasswoedTextEditingControler =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = '';
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: () => print('selected'),
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
                  CustomTextField(
                    controller: _nameTextEditingControler,
                    data: Icons.person,
                    hintText: 'Name',
                    isObsecure: false,
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
                    controller: _CPasswoedTextEditingControler,
                    data: Icons.lock_outline,
                    hintText: 'Comfirm Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () => ("clicked"),
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
}
