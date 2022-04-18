import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/model/user_model.dart';
import 'package:flutter2_test_firebase/states/saler_service.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/utility/my_dialog.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
import 'package:flutter2_test_firebase/widgets/show_progress.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileSeller extends StatefulWidget {
  final UserModel userModel;
  const EditProfileSeller({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditProfileSeller> createState() => _EditProfileSellerState();
}

class _EditProfileSellerState extends State<EditProfileSeller> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  LatLng? latLng;
  final formKey = GlobalKey<FormState>();
  File? file;

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();

    userModel = widget.userModel;
    readData();
    findLatLng();
  }

  Future<Null> findLatLng() async
  {
    Position? position = await findPosition();

    if(position != null)
    {
      setState(() {
        latLng = LatLng(position.latitude, position.longitude) ;
      });
    }
    else
    {
    }

  }

  Future<Position?> findPosition() async
  {
    Position? position;
    try
    {
      position = await Geolocator.getCurrentPosition();
    }
    catch(exception)
    {
      position = null;
    }
    return position;
  }

  Future<Null> readData() async
  {
    setState(() {
      nameController.text = userModel!.name;
      addressController.text = userModel!.address ?? "";
      phoneController.text = userModel!.phone ?? "";
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile Seller"),
        actions: [
          IconButton(
            onPressed: () {
              processEditProfileSeller();
            },
            icon: Icon(Icons.edit),
            tooltip: "Edit Profile Seller",
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constrains) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [

                buildTitle("General : "),
                buildName(constrains),
                buildAddress(constrains),
                buildPhone(constrains),

                buildTitle('Avatar : '),
                buildAvatar(constrains),

                buildTitle("Location : "),
                buildMap(constrains),

                buildButtonEditProfile(),

              ],
            ),
          ),
        )
      ),
    );
  }

  ShowTitle buildTitle(String title)
  {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h2Style()
    );
  }

  Row buildName(BoxConstraints constrains)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constrains.maxWidth * 0.6,
          child: TextFormField(
            validator: (value){
              if(value!.isEmpty)
              {
                return "Please fill name.";
              }
              else
              {
                return null;
              }
            },
            controller: nameController,
            decoration: InputDecoration(
                labelText: "Name : ",
                border: OutlineInputBorder()
            ),
          )
        ),
      ],
    );
  }

  Row buildAddress(BoxConstraints constrains)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 16),
            width: constrains.maxWidth * 0.6,
            child: TextFormField(
              validator: (value){
                if(value!.isEmpty)
                {
                  return "Please fill address.";
                }
                else
                {
                  return null;
                }
              },
              maxLines: 3,
              controller: addressController,
              decoration: InputDecoration(
                  labelText: "Address : ",
                  border: OutlineInputBorder()
              ),
            )
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constrains)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: constrains.maxWidth * 0.6,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              validator: (value){
                if(value!.isEmpty)
                {
                  return "Please phone name.";
                }
                else
                {
                  return null;
                }
              },
              controller: phoneController,
              decoration: InputDecoration(
                  labelText: "Phone : ",
                  border: OutlineInputBorder()
              ),
            )
        ),
      ],
    );
  }

  Future<Null> createAvatar({ImageSource? source}) async
  {
    try
    {
      var result = await ImagePicker().getImage(source: source!, maxHeight: 800, maxWidth: 800);
      setState(() {
        file = File(result!.path);
      });
    }
    catch(e)
    {

    }
  }

  Row buildAvatar(BoxConstraints constrains)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey),),
          child: Row(
            children: [
              IconButton(onPressed: () => createAvatar(source: ImageSource.camera), icon: Icon(Icons.add_a_photo)),
              Container(
                  width: constrains.maxWidth * 0.6,
                  height: constrains.maxWidth * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: file == null ? buildShowImageNetwork() : Image.file(file!),
                  )
              ),
              IconButton(onPressed: () => createAvatar(source: ImageSource.gallery), icon: Icon(Icons.add_photo_alternate)),
            ],
          ),
        )
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork()
  {
    return CachedNetworkImage(
      imageUrl: "${MyConstant.domain}/uploads/avata/${userModel!.avata}",
      placeholder: (context, url) => ShowProgress(),
    );
  }

  Row buildMap(BoxConstraints constrains)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,),
          ),
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constrains.maxWidth * 0.75,
          height: constrains.maxWidth * 0.5,
          child: latLng == null
              ? ShowProgress()
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: latLng!,
                    zoom: 16
                  ),
                  markers: <Marker>[
                    Marker(
                      markerId: MarkerId("id"),
                      position: latLng!,
                      infoWindow: InfoWindow(title: "Your location", snippet: "lat = ${latLng!.latitude}, lng = ${latLng!.longitude}")
                    )
                  ].toSet(),
                ),
        ),
      ],
    );
  }

  ElevatedButton buildButtonEditProfile() => ElevatedButton.icon( onPressed: (){ processEditProfileSeller(); }, icon : Icon(Icons.edit), label: Text("Edit Profile Seller") );


  Future<Null> processEditProfileSeller()async
  {
    if(formKey.currentState!.validate())
    {
      MyDialog().showProgressDialog(context);

      String name     = nameController.text;
      String address  = addressController.text;
      String phone    = phoneController.text;
      String nameFile = "";

      Map<String, dynamic> map = {};
      FormData data;

      if(file != null)
      {
        String apiSaveProduct = MyConstant.domain + "/site/save-avata";
        int i = Random().nextInt(100000000);
        nameFile = 'avata$i.png';
        map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
        data = FormData.fromMap(map);
        await Dio().post(apiSaveProduct, data:data)
        .then((value) async {
          print("<======= Save Image =======>");
        });
      }

      map = {};
      map['id']      = userModel!.id;
      map['name']    = name;
      map['address'] = address;
      map['phone']   = phone;
      map['lat']     = latLng!.latitude;
      map['lng']     = latLng!.longitude;
      if(nameFile != "")
      {
        map['avata'] = nameFile;
      }

      data = FormData.fromMap(map);
      String path = MyConstant.domain + "/site/update-user";
      await Dio().post(path, data: data).then((resp) async {
        // Navigator.pop(context);
        // Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(builder: (context) => SalerService( indexWidget: 1, ) );
        Navigator.push(context, route );
      });


    }
  }


}
