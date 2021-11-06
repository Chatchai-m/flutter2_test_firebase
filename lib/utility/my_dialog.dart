import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';

class MyDialog
{
  Future<Null> showProgressDialog(BuildContext context) async
  {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        onWillPop: () async
        {
          return false;
        },
      ),
    );
  }


  Future<Null> alertLocationService(BuildContext context, String title, String subtitle) async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.image4,),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(title: subtitle, textStyle: MyConstant().h3Style()),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: Text('OK')
          ),
        ],
      )
    );
  }


  Future<Null> normalDialog(BuildContext context, String title, String message) async
  {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.image4,),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Style(),),
          subtitle: ShowTitle(title: message, textStyle: MyConstant().h3Style(),),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK")
          )
        ],
      )
    );
  }


}