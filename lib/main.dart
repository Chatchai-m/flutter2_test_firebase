import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/states/add_product.dart';
import 'package:flutter2_test_firebase/states/authen.dart';
import 'package:flutter2_test_firebase/states/buyer_service.dart';
import 'package:flutter2_test_firebase/states/create_account.dart';
import 'package:flutter2_test_firebase/states/rider_service.dart';
import 'package:flutter2_test_firebase/states/saler_service.dart';
import 'package:flutter2_test_firebase/states/test.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen' : (BuildContext context) => Authen(),
  '/createAccount' : (BuildContext context) => CreateAccount(),
  '/buyerService' : (BuildContext context) => BuyerService(),
  '/salerService' : (BuildContext context) => SalerService(),
  '/riderService' : (BuildContext context) => RiderService(),
  '/addProduct' : (BuildContext context) => AddProduct(),
  '/testPage' : (BuildContext context) => TestPage(),
};


String? initialRoute;

Future<Null> main() async
{

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString("type");

  print("#### type => $type");
  if(type?.isEmpty??true)
  {
    initialRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  }
  else
  {
    switch(type)
    {
      case "buyer":
        initialRoute = MyConstant.routeBuyerService;
        break;
      case "seller":
        initialRoute = MyConstant.routeSalerService;
        break;
      case "rider":
        initialRoute = MyConstant.routeRiderService;
        break;
    }
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MaterialColor materialColor = MaterialColor(0xff575900, MyConstant.mapMaterialColor);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData( primarySwatch:  materialColor ),
    );
  }
}
