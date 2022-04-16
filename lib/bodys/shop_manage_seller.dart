import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/model/user_model.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_progress.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopManageSeller extends StatefulWidget {
  final UserModel userModel;
  const ShopManageSeller({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShopManageSellerState createState() => _ShopManageSellerState();
}

class _ShopManageSellerState extends State<ShopManageSeller> {

  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              ShowTitle( title: "Name Shop : ", textStyle: MyConstant().h2Style(), ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShowTitle( title: userModel!.name, textStyle: MyConstant().h1Style(), ),
                  ),
                ],
              ),
              ShowTitle( title: "Address : ", textStyle: MyConstant().h2Style()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowTitle( title: "${userModel!.address}", textStyle: MyConstant().h1Style(), ),
                    )
                  ),
                ],
              ),
              ShowTitle(title: "Phone : ${userModel!.phone}", textStyle: MyConstant().h2Style()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ShowTitle(title: "Avatar", textStyle: MyConstant().h2Style()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: constraints.maxWidth * 0.8,
                    child: CachedNetworkImage(
                      imageUrl: "${MyConstant.domain}/uploads/avata/${userModel!.avata}",
                      placeholder: (context, url) => ShowProgress(),
                    ),
                  ),
                ],
              ),
              ShowTitle(title: "Location : ", textStyle: MyConstant().h2Style()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.8,
                    height: constraints.maxWidth * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse("${userModel!.lat}"),
                            double.parse("${userModel!.lng}")
                          ),
                          zoom: 16
                        ),
                        markers: <Marker>[
                          Marker(
                            markerId: MarkerId('id'),
                            position: LatLng(
                                double.parse("${userModel!.lat}"),
                                double.parse("${userModel!.lng}")
                            ),
                            infoWindow: InfoWindow(title: "You are here ",snippet: "lat : ${userModel!.lat}, lng : ${userModel!.lng}" )
                          )
                        ].toSet(),
                      ),
                    ),
                  )
                ],
              ),


            ],
          ),
        )),
      ),
    );
  }
}
