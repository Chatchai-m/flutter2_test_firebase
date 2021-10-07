import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_signout.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerService extends StatefulWidget
{
  const BuyerService({Key? key}) : super(key: key);

  @override
  _BuyerServiceState createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buyer"),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            UserAccountsDrawerHeader(accountName: null, accountEmail: null)
          ],
        ),
      ),
    );
  }
}

