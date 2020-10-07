import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickshopping/Config/config.dart';
import 'package:quickshopping/Orders/placeOrder.dart';
import 'package:quickshopping/Widgets/customAppbar.dart';
import 'package:quickshopping/Widgets/loadingWidget.dart';
import 'package:quickshopping/Widgets/wideButton.dart';
import 'package:quickshopping/Models//address.dart';
import 'package:quickshopping/Counters/changeAggress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'adAddress.dart';



class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
    );
  }

  noAddressCard(){
    return Card(


    );
  }
}

class AddressCard extends StatefulWidget {
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      
    );
  }
}

class KeyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}