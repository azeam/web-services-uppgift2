import "dart:convert";

import 'package:auth/helpers/token_helper.dart';
import 'package:auth/new_product.dart';
import 'package:auth/podos/product.dart';
import 'package:auth/variables/colors.dart';
import 'package:auth/variables/strings.dart';
import 'package:auth/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class Products extends StatefulWidget {
  Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int _selectedList = 0;

  Uri urlAll = Uri.parse(baseUrl + "/product/all");
  Uri urlFavorites = Uri.parse(baseUrl + "/product/favorites");
  Uri urlAddFavorite = Uri.parse(baseUrl + "/product/add-favorite");

  Future<List<Product>> fetchProduct() async {
    final response = await http.get(_selectedList == 0 ? urlAll : urlFavorites,
        headers: {"token": await getToken()});
    if (response.statusCode == 200) {
      var productList = json.decode(response.body) as List;
      List<Product> products =
          productList.map((i) => Product.fromJson(i)).toList();
      return products;
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future addFavorite(String name) async {
    var response = await http.put(urlAddFavorite,
        headers: {"token": await getToken()}, body: name);
    if (response.statusCode == 200) {
      snackbar(context, "Product added to favorites");
    } else {
      snackbar(context, "An error occurred: " + response.body.toString());
    }
  }

  void _onMenuChanged(int index) {
    setState(() {
      _selectedList = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedList == 0 ? "Product list" : "Favorites list"),
      ),
      body: FutureBuilder<List<Product>>(
          future: fetchProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              snackbar(context, "Error: " + snapshot.error.toString());
            }
            List<Product> products = snapshot.data ?? [];
            return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return ListTile(
                      title: Text(product.name),
                      trailing: IconButton(
                        icon: _selectedList == 0
                            ? Icon(Icons.add_box)
                            : Icon(Icons.favorite),
                        onPressed: () {
                          if (_selectedList == 0) addFavorite(product.name);
                        },
                      ));
                });
          }),
      floatingActionButton: _selectedList == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => NewProduct()));
              },
              icon: const Icon(Icons.library_add, color: CustomColors.bright),
              backgroundColor: CustomColors.dark,
              label: Text("ADD PRODUCT",
                  style: Theme.of(context).textTheme.button),
              shape: StadiumBorder(
                  side: BorderSide(color: CustomColors.bright, width: 1)))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedList,
        selectedItemColor: CustomColors.orange,
        backgroundColor: CustomColors.dark,
        onTap: _onMenuChanged,
      ),
    );
  }
}
