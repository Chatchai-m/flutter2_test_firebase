import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShowSignOut extends StatelessWidget {
  const ShowSignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async
          {
            SharedPreferences preference = await SharedPreferences.getInstance();
            preference.clear().then((value) async{
              Navigator.pushNamedAndRemoveUntil(context, MyConstant.routeAuthen, (route) => false);
            });
          },
          tileColor: Colors.red.shade900,
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: "Sign out",
            textStyle: MyConstant().h2SWhitetyle(),
          ),
          subtitle: ShowTitle(
              title: "Sign Out And go to authen",
              textStyle: MyConstant().h3WhiteStyle()
          ),
        ),
      ],
    );
  }
}
