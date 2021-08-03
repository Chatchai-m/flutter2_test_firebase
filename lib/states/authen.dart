import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';

class Authen extends StatefulWidget
{
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen>
{
  @override
  Widget build(BuildContext context)
  {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            buildImage(size),
            buildAppName()
          ],
        ),
      ),
    );
  }

  Row buildImage(double size)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.8,
          child: ShowImage(pathImage: MyConstant.image1)
        ),
      ],
    );
  }

  Row buildAppName()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(title: MyConstant.appName, textStyle: MyConstant().h1Style()),
      ],
    );
  }
  
  
}
