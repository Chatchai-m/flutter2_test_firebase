import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/bodys/shop_manage_seller.dart';
import 'package:flutter2_test_firebase/bodys/show_order_seller.dart';
import 'package:flutter2_test_firebase/bodys/show_product_seller.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_signout.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';

class SalerService extends StatefulWidget
{
  const SalerService({Key? key}) : super(key: key);

  @override
  _SalerServiceState createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService>
{

  List<Widget> widgets = [
    ShowOrderSeller(),
    ShopManageSeller(),
    ShowProductSeller(),
  ];

  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seller"),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduct()
              ],
            )
          ],
        ),
      ),

      body: widgets[indexWidget],
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
