import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/model/product_model.dart';
import 'package:flutter2_test_firebase/states/edit_product.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/utility/my_dialog.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
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
    int id_seller = preferences!.getInt('id')!;
    String api = MyConstant.domain + "/site/load-product";


    product_models.clear();

    Map<String, dynamic> map = {};
    map["id_seller"] = id_seller;
    FormData data = FormData.fromMap(map);

    await Dio().post(api, data: data).then((value) {

      var items = jsonDecode(value.data);
      print(items);
      if(items.length == 0)
      {

      }
      else
      {
        for(var item in jsonDecode(value.data))
        {
          ProductModel model = ProductModel.fromMap(item);
          // //
          // print( item['price'].runtimeType );
          // // print(model.name_seller);
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
        onPressed: () => Navigator.pushNamed(context, MyConstant.routeAddProduct ).then((value) {
          setState(() {
            load = true;
            haveData = false;
          });
          loadValueFromAPI();
        }),
        child: Text("Add"),
      ),
    );
  }


  String createUrl(String string)
  {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = MyConstant.domain + "/uploads/product/" + strings[0];
    return url;
  }


  ListView buildBuildListView(BoxConstraints constraints)
  {
    return ListView.builder(
      itemCount: product_models.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.5 ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowTitle(title: product_models[index].name, textStyle: MyConstant().h2Style(),),
                  Container(
                    width: constraints.maxWidth * 0.5,
                    height: constraints.maxWidth * 0.4,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: createUrl(product_models[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) => ShowImage(pathImage: MyConstant.image1,),
                    ) //Image.network(createUrl(product_models[index].images), fit: BoxFit.cover)
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(5),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(title: "Price : ${product_models[index].price} THB", textStyle: MyConstant().h2Style(),),
                  ShowTitle(
                    title: product_models[index].detail,
                    textStyle: MyConstant().h3Style(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: ()
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProduct(productModel: product_models[index],)
                            )
                          ).then((value) {
                            setState(() {
                              load = true;
                              haveData = false;
                            });
                            loadValueFromAPI();
                          });
                        },
                        icon: Icon(Icons.edit_outlined, size: 30, color: MyConstant.dark,)
                      ),
                      IconButton(
                        onPressed: () async
                        {
                          confirmDialogDelete(product_models[index]);
                        },
                        icon: Icon(Icons.delete_outline, size: 30, color: MyConstant.dark,)
                    ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }


  Future<Null> confirmDialogDelete(ProductModel productModel) async
  {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: createUrl(productModel.images),
            placeholder: (context, url) => ShowProgress(),
            errorWidget: (context, url, error) => ShowImage(pathImage: MyConstant.image1,),
          ),
          title: ShowTitle(title: "Delete ${productModel.name}", textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(title: productModel.detail, textStyle: MyConstant().h3Style()),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async
                  {

                    Map<String, dynamic> map = {};
                    map["id"] = productModel.id;

                    FormData data = FormData.fromMap(map);

                    MyDialog().showProgressDialog(context);

                    String api_delete = MyConstant.domain + "/site/delete-product";
                    await Dio().post(api_delete, data: data).then((value){
                      Navigator.pop(context);
                      Navigator.pop(context);

                      loadValueFromAPI();

                      setState(() {
                        load = true;
                        haveData = false;
                      });
                    });

                  },
                  child: Text("Delete")
              ),
              TextButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")
              ),
            ],
          )
        ],
      )
    );
  }




}
