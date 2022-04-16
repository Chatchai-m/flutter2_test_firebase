import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/model/product_model.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/utility/my_dialog.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget{
  final ProductModel? productModel;
  const EditProduct({ Key? key,  this.productModel }) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct>
{
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  List<String> pathImages = [];
  List<File?> files = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    convertStringToArray();
    print(productModel!.name);
    nameController.text = productModel!.name;
    priceController.text = productModel!.price;
    detailController.text = productModel!.detail;
  }

  void convertStringToArray()
  {
    String string = productModel!.images;
    string = string.substring(1, string.length - 1);
    print("<================>");
    print(string);
    List<String> strings = string.split(',');
    for(var item in strings)
    {
      pathImages.add(item.trim());
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: ()
            {
              processEdit();
            },
            icon: Icon(Icons.edit)
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constrains) =>
        Center(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle("General : "),
                    buildName(constrains),
                    buildPrice(constrains),
                    buildDetail(constrains),
                    buildTitle("Image Product : "),
                    buildImage(constrains, 0),
                    buildImage(constrains, 1),
                    buildImage(constrains, 2),
                    buildImage(constrains, 3),

                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      width: constrains.maxWidth,
                      child: ElevatedButton.icon(
                        onPressed: ()
                        {
                          processEdit();
                        },
                        icon: Icon(Icons.edit), label: Text("Edit Product")
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShowTitle(title: title , textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Row buildName(BoxConstraints constrains) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // margin: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.only(bottom: 10),
          width: constrains.maxWidth * 0.75,
          child: TextFormField(
            controller: nameController,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return 'Please Fill Detail in Blank';
              }
              else
              {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name Product ',
              prefixIcon: Icon(
                Icons.production_quantity_limits_sharp,
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
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),

            ),
          ),
        ),
      ],
    );
  }

  Row buildPrice(BoxConstraints constrains) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // margin: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.only(bottom: 10),
          width: constrains.maxWidth * 0.75,
          child: TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return 'Please Fill Detail in Blank';
              }
              else
              {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Price',
              prefixIcon: Icon(
                Icons.money_sharp,
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
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),

            ),
          ),
        ),
      ],
    );
  }

  Row buildDetail(BoxConstraints constrains) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // margin: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.only(bottom: 10),
          width: constrains.maxWidth * 0.75,
          child: TextFormField(
            controller: detailController,
            validator: (value)
            {
              if(value!.isEmpty)
              {
                return 'Please Fill Detail in Blank';
              }
              else
              {
                return null;
              }
            },
            maxLines: 4,
            decoration: InputDecoration(
                hintStyle: MyConstant().h3Style(),
                hintText: 'Product Detail',
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Icon(
                    Icons.details_outlined,
                    color: MyConstant.dark,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(30),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(30),
                )
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> chooseImage(int index, ImageSource source) async
  {
    try
    {
      var result = await ImagePicker().getImage(source: source, maxHeight: 800, maxWidth: 800);

      setState(() {
        files[index] = File(result!.path);
      });
    }
    catch(e)
    {

    }
  }

  Container buildImage(BoxConstraints constrains, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all( color: Colors.grey.shade400 ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: ()
              {
                chooseImage(index, ImageSource.camera);
              },
              icon: Icon(Icons.add_a_photo)
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              width: constrains.maxWidth * 0.5,
              height: constrains.maxWidth * 0.4,
              child: files[index] == null ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: MyConstant.domain + '/uploads/product/' + pathImages[index]
              ) : Image.file(files[index]!)
          ),
          IconButton(
              onPressed: ()
              {
                chooseImage(index, ImageSource.gallery);
              },
              icon: Icon(Icons.add_photo_alternate)
          ),
        ],
      ),
    );
  }

  Future<Null> processEdit() async
  {
    if(formKey.currentState!.validate())
    {
      MyDialog().showProgressDialog(context);

      String name = nameController.text;
      String price = priceController.text;
      String detail = detailController.text;

      Map<String, dynamic> map = {};
      FormData data;
      List<String> nameFiles = [];
      for(int i =0; i < files.length; i++)
      {
        File? file = files[i];
        print("<==== File ${i} ====>");
        if(file == null)
        {
          nameFiles.add(pathImages[i]);
        }
        else
        {
          String apiSaveProduct = MyConstant.domain + "/site/save-product-image";
          int i = Random().nextInt(100000000);
          String nameFile = 'product$i.png';

          nameFiles.add(nameFile);
          map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
          data = FormData.fromMap(map);

          await Dio().post(apiSaveProduct, data:data)
          .then((value) async {
            print("<======= Save Image =======>");
          });
        }
      }

      print("<====== Save data ======>");
      map = {};
      map['id']          = productModel!.id;
      map['name']        = name;
      map['price']       = price;
      map['detail']      = detail;
      map['images']      = nameFiles.toString();

      data = FormData.fromMap(map);
      String path = MyConstant.domain + "/site/save-product";
      await Dio().post(path, data: data).then((resp) async {
        print(resp);
        Navigator.pop(context);
        Navigator.pop(context);
      });

      print(nameFiles.toString());

    }
  }

}
