import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/utility/my_dialog.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
import 'package:flutter2_test_firebase/widgets/show_progress.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async
  {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if(locationService)
    {
      // print("Service location open");
      locationPermission = await Geolocator.checkPermission();
      if(
          ( locationPermission == LocationPermission.denied )
          ||
          ( locationPermission == LocationPermission.deniedForever )
        )
      {
        locationPermission = await Geolocator.requestPermission();
        if(
            ( locationPermission == LocationPermission.denied )
            ||
            ( locationPermission == LocationPermission.deniedForever )
          )
        {
          MyDialog().alertLocationService(context, "ไม่อนุญาติแชร์ Location", "โปรดแชร์ Location");
        }
        else
        {
          findLatLng();
        }
      }
      else
      {
        findLatLng();
      }
    }
    else
    {
      // print("Service location close");
      MyDialog().alertLocationService(context, "Location Service ปิดอยู่ ?", "กรุณาเปิด Location ด้วยครับ");
    }
  }

  Future<Null> findLatLng() async
  {
    Position? position = await findPosition();

    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
    });
  }

  Future<Position?> findPosition() async
  {
    Position position;
    try
    {
      position = await Geolocator.getCurrentPosition();
      return position;
    }
    catch(e)
    {
      return null;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildCreateNewAccount()
        ],
        title: Text('Create new account'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
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
                  buildTitle("แสดงพิดกัดที่คุณอยู่"),
                  buildMap(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCreateNewAccount()
  {
    return IconButton(
      onPressed: ()
      {
        if(formKey.currentState!.validate())
        {
          // MyDialog().normalDialog(context, "ยังไม่ได้กรอกข้อมูล", "กรุณากรอกข้อมูลให้ครบ");
          uploadPicture();
        }
      },
      icon: Icon(Icons.cloud_upload)
    );
  }

  Future<Null> uploadPicture()async
  {
    String name     = nameController.text;
    String address  = addressController.text;
    String phone    = phoneController.text;
    String user     = userController.text;
    String password = passwordController.text;

    print("name = $name, address = $address, phone = $phone, user = $user, password = $password");
    print(MyConstant.domain );
    String path = MyConstant.domain + "/site/read-user";
    FormData formData = new FormData.fromMap({
      "user": user,
    });

    await Dio()
        .post(path, data: formData )
        .then(
          (value) async
          {
            // print("response");
            // print(value);
            var result = jsonDecode(value.data);
            var result_user = result["data"];
            // print(user.runtimeType);
            if(result_user == null)
            {

              Map<String, dynamic> map = {
                "id"       : 0,
                "name"     : name,
                "address"  : address,
                "phone"    : phone,
                "user"     : user,
                "password" : password,
                "type"     : typeUser,
                "lat"      : lat,
                "lng"      : lng
              };

              if(file == null)
              {
                await processInsertMysql(map);
              }
              else
              {
                String apiSaveImage = MyConstant.domain + "/site/save-avata";
                int i = Random().nextInt(1000000);
                String nameAvata = 'avata$i.jpg';
                Map<String, dynamic> map_file = Map();
                map_file['file'] = await MultipartFile.fromFile(file!.path, filename: nameAvata);
                FormData data = FormData.fromMap(map_file);

                await Dio().post(apiSaveImage, data: data).then(
                  (value) async {
                    print(value);
                    map["avata"] = nameAvata;
                    await processInsertMysql(map);
                  }
                );
              }
            }
            else
            {
              MyDialog().normalDialog(context, "มีชื่อผู้ใช้งานนี้ในระบบแล้ว", "กรุณาตรวจสอบใหม่อีกครั้ง");
            }
          }
        );
  }

  Future<Null> processInsertMysql(Map<String, dynamic> data) async
  {
    String path = MyConstant.domain + "/site/update-user";
    FormData formData = new FormData.fromMap(data);
    await Dio().post(path, data: formData)
    .then(
      (value)
      {
        print(value);
        if(value.toString() == "true")
        {
          Navigator.pop(context);
        }
        else
        {
          MyDialog().normalDialog(context, "Create user fail.", "Please try again.");
        }
      }
    );
  }

  Widget buildTitle(String title)
  {
    return Container(
      margin: EdgeInsets.all(16),
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
            controller: nameController,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return "กรุณากรอก Name ";
              }
              else
              {

              }
            },
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
            controller: addressController,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return "กรุณากรอก Address ";
              }
              else
              {

              }
            },
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
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return "กรุณากรอก Phone ";
              }
              else
              {

              }
            },
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
            controller: userController,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return "กรุณากรอก User ";
              }
              else
              {

              }
            },
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
            controller: passwordController,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return "กรุณากรอก Password ";
              }
              else
              {

              }
            },
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

  Set<Marker> setMarker() => <Marker>[
    Marker(
      markerId: MarkerId('id'),
      position: LatLng(lat!, lng!),
      infoWindow: InfoWindow(title: 'คุณอยู่นี่', snippet: 'Lat = $lat, Lng = $lng'),
    )
  ].toSet();

  Widget buildMap()
  {
    return Container(
      width: double.infinity,
      height: 300,
      child: lat == null ? ShowProgress() :
        GoogleMap(
          initialCameraPosition : CameraPosition(
            target: LatLng(lat!, lng!),
            zoom: 16
          ),
          onMapCreated: (controller)
          {

          },
          markers: setMarker(),
        ) //Text("Lat = $lat, Lng = $lng", style: MyConstant().h3Style(),)
    );
  }
}
