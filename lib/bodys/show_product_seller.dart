import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/model/product_model.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/widgets/show_progress.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  _ShowProductSellerState createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {

  bool load = true;
  SharedPreferences? preferences;
  bool haveData = false;
  List<ProductModel> product_models = [];

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async
  {

    preferences = await SharedPreferences.getInstance();
    String id_seller = preferences!.getString('id')!;
    String api = MyConstant.domain + "/site/load-product";


    Map<String, dynamic> map = {};
    map["id_seller"] = id_seller;
    FormData data = FormData.fromMap(map);

    await Dio().post(api, data: data).then((value) {

      var items = jsonDecode(value.data);
      if(items.length == 0)
      {

      }
      else
      {
        for(var item in jsonDecode(value.data))
        {
          ProductModel model = ProductModel.fromMap(item);
          //
          print(model);
          // print(model.name_seller);
          product_models.add(model);
        }

        haveData = true;
      }

      setState(() {
        load = false;
      });

    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  load ? ShowProgress()
                  : haveData ? LayoutBuilder(builder: (context, contraints) => buildBuildListView(contraints),)
                             : Center(
                                 child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       ShowTitle(title: "No Product", textStyle: MyConstant().h1Style()),
                                       ShowTitle(title: "Please add product", textStyle: MyConstant().h2Style())
                                     ],
                                 ),
                               ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () => Navigator.pushNamed(context, MyConstant.routeAddProduct ),
        child: Text("Add"),
      ),
    );
  }

 ListView buildBuildListView(BoxConstraints constraints)
 {
   return ListView.builder(
     itemCount: product_models.length,
     itemBuilder: (context, index) => Card(
       child: Row(
         children: [
           Container(
             padding: EdgeInsets.all(4),
             width: constraints.maxWidth * 0.5 - 4,
             child: ShowTitle(title: product_models[index].name, textStyle: MyConstant().h2Style(),),
           ),
           Container(
             padding: EdgeInsets.all(4),
             width: constraints.maxWidth * 0.5 - 4,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 ShowTitle(title: "Price : ${product_models[index].price} THB", textStyle: MyConstant().h2Style(),),
                 ShowTitle(title: product_models[index].detail, textStyle: MyConstant().h3Style(),),
               ],
             ),
           )
         ],
       ),
     )
   );
 }

}
