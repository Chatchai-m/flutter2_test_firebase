import 'package:flutter/material.dart';

class MyConstant
{
  //General
  static String appName = "Flutter2 test firebase";
  static String domain  = "https://6bb47948e323.ngrok.io";

  //Route
  static String routeAuthen        = "/authen";
  static String routeCreateAccount = "/createAccount";
  static String routeBuyerService  = "/buyerService";
  static String routeSalerService  = "/salerService";
  static String routeRiderService  = "/riderService";

  //Image
  static String image1 = "images/image1.png";
  static String image2 = "images/image2.png";
  static String image3 = "images/image3.png";
  static String image4 = "images/image4.png";
  static String avatar = "images/avatar.png";

  //Color
  static Color primary = Color(0xffa9b22b);
  static Color dark = Color(0xff778300);
  static Color light = Color(0xffdde45e);

  //Style
  TextStyle h1Style() => TextStyle(
    fontSize: 24,
    color: dark,
    fontWeight: FontWeight.bold
  );

  TextStyle h2Style() => TextStyle(
      fontSize: 18,
      color: dark,
      fontWeight: FontWeight.w800
  );

  TextStyle h3Style() => TextStyle(
      fontSize: 14,
      color: dark,
      fontWeight: FontWeight.normal
  );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
    primary: MyConstant.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30)
    )
  );
}