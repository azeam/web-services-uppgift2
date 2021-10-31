import 'dart:convert';

import 'package:auth/helpers/number_helper.dart';
import 'package:auth/helpers/token_helper.dart';
import 'package:auth/podos/product.dart';
import 'package:auth/products.dart';
import 'package:auth/variables/colors.dart';
import 'package:auth/variables/strings.dart';
import 'package:auth/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewProduct extends StatefulWidget {
  NewProduct({Key? key}) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final formKey = GlobalKey<FormState>();
  Product product = Product(name: "", description: "", price: 0);
  Uri url = Uri.parse(baseUrl + "/product/create");

  Future save() async {
    var response = await http.put(url,
        headers: {
          "token": await getToken(),
          "content-type": "application/json"
        },
        body: json.encode(product.toJson()));

    if (response.statusCode == 200) {
      snackbar(context, response.body.toString());
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Products(),
          ));
    } else {
      snackbar(context, "An error occurred: " + response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New product"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Center(
                          child: Text(
                            "NEW PRODUCT",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: TextEditingController(text: product.name),
                        onChanged: (val) {
                          product.name = val;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Product name is empty";
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Product name",
                            hintText: "Enter a product name"),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            controller: TextEditingController(
                                text: product.description),
                            onChanged: (val) {
                              product.description = val;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Description is empty";
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Description",
                                hintText: "Enter product description"),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            controller: TextEditingController(
                                text: product.price.toString()),
                            onChanged: (val) {
                              product.price = int.parse(val);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Price is empty";
                              }
                              if (!isNumeric(value)) {
                                return "Not a valid price";
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Price",
                                hintText: "Enter product price"),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: CustomColors.dark,
                          border: Border.all(
                              color: CustomColors.bright, width: 1.5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              save();
                            }
                          },
                          child: Text(
                            "SAVE",
                            style: TextStyle(color: CustomColors.bright),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Products()));
                          },
                          child: Text("Back to product list"))
                    ],
                  ),
                ))));
  }
}
