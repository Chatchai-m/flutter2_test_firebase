import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/bodys/shop_manage_seller.dart';
import 'package:flutter2_test_firebase/bodys/show_order_seller.dart';
import 'package:flutter2_test_firebase/bodys/show_product_seller.dart';
import 'package:flutter2_test_firebase/model/user_model.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_progress.dart';
import 'package:flutter2_test_firebase/widgets/show_signout.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalerService extends StatefulWidget
{
  const SalerService({Key? key}) : super(key: key);

  @override
  _SalerServiceState createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService>
{

  List<Widget> widgets = [
  ];

  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int id = sharedPreferences.getInt('id')!;

    String api = MyConstant.domain + "/site/read-user";
    FormData data = FormData.fromMap({ "id" : id });
    await Dio().post(api, data: data)
    .then((value) async{
      var rs = jsonDecode(value.data);
      if(rs["data"] != null)
      {
        setState(() {
          userModel = UserModel.fromMap(rs["data"]);
          widgets.add(ShowOrderSeller());
          widgets.add(ShopManageSeller(userModel: userModel!,));
          widgets.add(ShowProductSeller());
        });
      }
      else
      {
        print("<=========== User not found. ===========>");
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seller"),
      ),
      drawer: widgets.length == 0 ? SizedBox() : Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                buildHead(),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduct()
              ],
            )
          ],
        ),
      ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHead() {
    return UserAccountsDrawerHeader(
      otherAccountsPictures: [
        IconButton(
          onPressed: (){}, icon: Icon(Icons.face_outlined),
          iconSize: 36,
          color: MyConstant.light,
          tooltip: "",
        )
      ],
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [ MyConstant.light, MyConstant.dark ],
          center: Alignment(-0.8,-0.2),
          radius: 1
        )
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: userModel == null ? NetworkImage("https://likebroker.co.th/uploads/company_logo//logo_8.png") : NetworkImage(MyConstant.domain + '/uploads/avata/${userModel!.avata}'),
      ),
      accountName: Text(userModel == null ? "Name ?" : userModel!.name),
      accountEmail: Text(userModel == null ? "Type ? " : userModel!.type)
    );
  }

  ListTile menuShowOrder()
  {
    return ListTile(
      onTap: ()
      {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1),
      title: ShowTitle(title: "Show Order", textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(title: "รายละเอียดการของ Order ที่สั่ง", textStyle: MyConstant().h3Style()),
    );
  }

  ListTile menuShopManage()
  {
    return ListTile(
      onTap: ()
      {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2),
      title: ShowTitle(title: "Shop Manage", textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(title: "แสดงรายละเอียดของหน้าร้าน ให้ลูกค้าเห็น", textStyle: MyConstant().h3Style()),
    );
  }

  ListTile menuShowProduct()
  {
    return ListTile(
      onTap: ()
      {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_3),
      title: ShowTitle(title: "Show Product", textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(title: "แสดงรายละเอียดของสินค้า", textStyle: MyConstant().h3Style()),
    );
  }

}
