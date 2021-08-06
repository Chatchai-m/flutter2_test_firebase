import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';

class MyDialog
{
  Future<Null> alertLocationService(BuildContext context) async
  {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.image4,),
          title: ShowTitle(title: "Location Service ปิดอยู่ ?", textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(title: "กรุณาเปิด Location ด้วยครับ", textStyle: MyConstant().h3Style()),
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
}