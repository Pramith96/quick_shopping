import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickshopping/Admin/adminShiftOrders.dart';
import 'package:quickshopping/Widgets/loadingWidget.dart';
import 'package:quickshopping/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;

  @override
  Widget build(BuildContext context) {
    return displayAdminHomeScreen();
  }

  displayAdminHomeScreen() {
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
        leading: IconButton(
          icon: Icon(Icons.border_color, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              'LogOut',
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.teal, Colors.lightGreenAccent],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two, color: Colors.white, size: 200.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                child: Text('Upload new item', style: TextStyle(fontSize: 20.0, color: Colors.white),),
                color: Colors.blueAccent,
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  takeImage(mContext){
    return showDialog(
      context: mContext,
      builder: (con){
        return SimpleDialog(
          title: Text('Item image', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
          children: [
              SimpleDialogOption(
                child: Text('Capture with Camara', style: TextStyle(color: Colors.blueAccent), ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text('Select from gallery', style: TextStyle(color: Colors.blueAccent), ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text('Cancel', style: TextStyle(color: Colors.blueAccent), ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
          ],
        );
      });
  }
  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imageFile;
    });
  }
}
