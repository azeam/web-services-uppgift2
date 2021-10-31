import 'dart:convert';

import 'package:auth/helpers/token_helper.dart';
import 'package:auth/podos/user.dart';
import 'package:auth/products.dart';
import 'package:auth/register.dart';
import 'package:auth/variables/strings.dart';
import 'package:auth/widgets/snackbar.dart';
import 'package:auth/widgets/user_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  User user = User();
  Uri url = Uri.parse(baseUrl + "/user/login");

  Future save() async {
    var response = await http.post(url, headers: user.toJson());

    if (response.statusCode == 200) {
      await saveToken(response.body.toString());
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
          title: Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child:
                  userForm(context, "login", save, user, formKey, Register())),
        ));
  }
}
