import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/utility/my_constant.dart';
import 'package:flutter2_test_firebase/utility/my_dialog.dart';
import 'package:flutter2_test_firebase/widgets/show_image.dart';
import 'package:flutter2_test_firebase/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({ Key? key }) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct>
{
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile()
  {
    for(var i = 0; i < 4; i ++)
    {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: ()
            {
              processAddProduct();
            },
            icon: Icon(Icons.cloud_upload)
          )
        ],
        title : Text("Add Product"),
      ),
      body: LayoutBuilder(
        builder: (context, constrains) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key : formKey,
                child: Column(
                  children: [
                    buildProductName(constrains),
                    buildProductPrice(constrains),
                    buildProductDetail(constrains),
                    buildImage(constrains),
                    buildAddProduct(constrains)
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }





  Widget buildProductName(BoxConstraints constrains)
  {
    return Container(
      width: constrains.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: nameController,
        validator: (value)
        {
          if(value!.isEmpty)
          {
            return 'Please Fill Name in Blank';
          }
          else
          {
            return null;
          }
        },
        // validator: (value)
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
    );
  }




  Widget buildProductPrice(BoxConstraints constrains)
  {
    return Container(
      width: constrains.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: priceController,
        validator: (value)
        {
          if(value!.isEmpty)
          {
            return 'Please Fill Price in Blank';
          }
          else
          {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        // validator: (value)
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'Price Product ',
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
          )
        ),
      ),
    );
  }




  Widget buildProductDetail(BoxConstraints constrains)
  {
    return Container(
      width: constrains.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
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
    );
  }




  Future<Null> processImagePicker( ImageSource source, int index ) async
  {
    try
    {
      var result = await ImagePicker().getImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    }
    catch(e)
    {

    }
  }




  Future<Null> chooseSourceImageDialog(int index) async
  {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.image4,),
          title: ShowTitle(title: 'Source Image ${index + 1} ?', textStyle: MyConstant().h2Style(),),
          subtitle: ShowTitle(title: 'Please Tab on Camera or Gallery', textStyle: MyConstant().h3Style(),),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text("Camera")
              ),
              TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text("Gallery")
              ),
            ],
          ),
        ],
      )
    );
  }




  Widget buildImage(BoxConstraints constrains) {
    return Column(
      children: [
        Container(
          width: constrains.maxWidth * 0.75,
          height: constrains.maxWidth * 0.75,
          child: file == null ? Image.asset(MyConstant.image5) : Image.file(file!)
        ),
        Container(
          width: constrains.maxWidth * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: (){
                    chooseSourceImageDialog(0);
                  },
                  child: files[0] == null ? Image.asset(MyConstant.image5) : Image.file(files[0]!, fit:BoxFit.cover)
                )
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: (){
                    chooseSourceImageDialog(1);
                  },
                  child: files[1] == null ? Image.asset(MyConstant.image5) : Image.file(files[1]!, fit:BoxFit.cover)
                )
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: (){
                    chooseSourceImageDialog(2);
                  },
                  child: files[2] == null ? Image.asset(MyConstant.image5) : Image.file(files[2]!, fit:BoxFit.cover)
                )
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: (){
                    chooseSourceImageDialog(3);
                  },
                  child: files[3] == null ? Image.asset(MyConstant.image5) : Image.file(files[3]!, fit:BoxFit.cover)
                )
              ),

            ],
          ),
        ),
      ],
    );
  }




  Widget buildAddProduct(BoxConstraints constrains)
  {
    return Container(
      width: constrains.maxWidth * 0.75,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: ()
        {
          processAddProduct();
        },
        child: Text("Add Product"),
      ),
    );
  }

  Future<Null> processAddProduct() async
  {
    if(formKey.currentState!.validate())
    {
      bool checkFile = true;
      for(var item in files)
      {
        if(item == null)
        {
          checkFile = false;
        }
      }

      print("<===== Save Data =====>");
      if(checkFile)
      {
        MyDialog().showProgressDialog(context);

        int loop = 0;
        String apiSaveProduct = MyConstant.domain + "/site/save-product-image";
        List<String> nameFiles = [];
        for(var item in files)
        {
          int i = Random().nextInt(100000000);
          String nameFile = 'product$i.png';
          Map<String, dynamic> map = {};
          map['file'] = await MultipartFile.fromFile(item!.path, filename: nameFile);

          nameFiles.add(nameFile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveProduct, data:data)
          .then((value) async {
            print(value);
            loop ++;
            print("success $i");
            if(loop >= files.length)
            {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              map = {};
              map['id'] = 0;
              map['id_seller']   = preferences.getString("id");
              map['name_seller'] = preferences.getString("name");
              map['name']        = nameController.text;
              map['price']       = priceController.text;
              map['detail']      = detailController.text;
              map['images']      = nameFiles.toString();
              print("Image => " + nameFiles.toString() );
              Navigator.pop(context);

              data = FormData.fromMap(map);
              String path = MyConstant.domain + "/site/save-product";
              await Dio().post(path, data: data).then((resp) {
                print("Success");
                print(resp);
                Navigator.pop(context);
              });

            }
          });



        }
      }
      else
      {
        MyDialog().normalDialog(context, "More Image", "Please Choose More Image");
      }

    }
  }




}