import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/utility/my_dialog.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccount extends StatefulWidget
{
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount>
{
  String? typeUser = "rider";
  File? file;

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async
  {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if(locationService)
    {
      print("Service location open");
    }
    else
    {
      print("Service location close");
      MyDialog().alertLocationService(context);
    }

  }

  @override
  Widget build(BuildContext context)
  {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new account'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            buildTitle("ข้อมูลทั่วไป"),
            buildName(size),
            buildTitle("ชนิดของ User"),
            buildRadio(size, "ผู้ซื้อ (Buyer)", "buyer"),
            buildRadio(size, "ผู้ขาย (Seller)", "seller"),
            buildRadio(size, "ผู้ส่ง (Rider)", "rider"),
            buildTitle("ข้อมูลพื้นฐาน"),
            buildAddress(size),
            buildPhone(size),
            buildUser(size),
            buildPassword(size),
            buildTitle("รูปภาพ"),
            buildSubTitle(),
            buildAvatar(size),
          ],
        ),
      ),
    );
  }

  Container buildTitle(String title)
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style()
      ),
    );
  }

  Row buildName(double size)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name',
              prefixIcon: Icon(
                Icons.fingerprint,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadio(double size, String title, String value)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            title: ShowTitle(
              title: title,
              textStyle: MyConstant().h3Style()
            ),
            value: value,
            groupValue: typeUser,
            onChanged: (value)
            {
              setState(() {
                typeUser = value as String?;
              });
            }
          ),
        ),
      ],
    );
  }

  Row buildAddress(double size)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Address',
              hintStyle: MyConstant().h3Style(),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                child: Icon(
                  Icons.home,
                  color: MyConstant.dark,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Phone',
              prefixIcon: Icon(
                Icons.phone,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double size)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User',
              prefixIcon: Icon(
                Icons.perm_identity,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubTitle()
  {
    return ShowTitle(
      title: "เป็นรูปภาพ ที่แสดงความเป็นตัวตนของ User ( แต่ถ้าไม่สะดวกแชร์ เราจะแสดงภาพ default แทน )",
      textStyle: MyConstant().h3Style()
    );
  }

  Future<Null> chooseImage(ImageSource source) async
  {
    try
    {
      var result = await ImagePicker().pickImage(source: source, maxHeight: 800, maxWidth: 800);

      setState(() {
        file = File(result!.path);
      });
    }
    catch (e)
    {
      print(e);
    }
  }

  Widget buildAvatar(double size)
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: ()
          {
            chooseImage(ImageSource.camera);
          },
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          )
        ),

        Container(
          margin: EdgeInsets.symmetric( vertical: 16 ),
          width: size * 0.6,
          child: file == null ? ShowImage(pathImage: MyConstant.avatar) : Image.file( file! ),
        ),

        IconButton(
          onPressed: ()
          {
            chooseImage(ImageSource.gallery);
          },
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          )
        ),
      ],
    );
  }
}
