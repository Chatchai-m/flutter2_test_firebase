import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/model/user_model.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/utility/my_dialog.dart';
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

  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                buildImage(size),
                buildAppName(),
                buildUser(size),
                buildPassword(size),
                buildButton(size),
                buildCreateAccount(),
              ],
            ),
          ),
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
                return "Please fill User in blank";
              }
              else
              {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User',
              prefixIcon: Icon(
                Icons.account_circle_outlined,
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
                return "Please fill User in blank";
              }
              else
              {
                return null;
              }
            },
            obscureText: statusRedEye,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: MyConstant.dark,
              ),
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: Icon( statusRedEye ? Icons.remove_red_eye : Icons.visibility_off ),
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

  Row buildButton(double size)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: ()
            {
              if(formKey.currentState!.validate())
              {
                String user = userController.text;
                String password = passwordController.text;
                print("user : $user, password : $password");
                checkAuthen(user: user, password: password);
              }
            },
            child: Text("Login")
          ),
        ),
      ],
    );
  }

  Row buildCreateAccount()
  {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: "New Account ?",
          textStyle: MyConstant().h3Style()
        ),
        TextButton(
          onPressed: ()
          {
            Navigator.pushNamed(context, MyConstant.routeCreateAccount);
          },
          child: Text("Create Account")
        )
      ],
    );
  }



  Future<Null> checkAuthen({ String? user, String? password }) async
  {
    String api = MyConstant.domain + "/site/read-user";

    FormData data = FormData.fromMap({ "user" : user });
    await Dio().post(api, data: data).then(
      (value)
      {
        var rs = jsonDecode(value.data);
        print(value);
        if(rs["data"] == null)
        {
          MyDialog().normalDialog(context, "User false !!!", "No $user in database.");
        }
        else
        {
          rs["data"]["id"] = rs["data"]["id"].toString();
          rs["data"]["createdAt"] = rs["data"]["created_at"];
          rs["data"]["updatedAt"] = rs["data"]["updated_at"];

          UserModel userModel = UserModel.fromMap(rs["data"]);
          if(password == userModel.password)
          {
            String? type = userModel.type;
            switch(type)
            {
              case "buyer":
                Navigator.pushNamedAndRemoveUntil(context, MyConstant.routeBuyerService, (route) => false);
                break;
              case "seller":
                Navigator.pushNamedAndRemoveUntil(context, MyConstant.routeSalerService, (route) => false);
                break;
              case "rider":
                Navigator.pushNamedAndRemoveUntil(context, MyConstant.routeRiderService, (route) => false);
                break;
            }
          }
          else
          {
            MyDialog().normalDialog(context, "Password fail !!!!", "");
          }
        }
      }
    );
  }

}
