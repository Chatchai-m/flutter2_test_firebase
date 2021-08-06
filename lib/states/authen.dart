import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
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

  @override
  Widget build(BuildContext context)
  {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
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

}
