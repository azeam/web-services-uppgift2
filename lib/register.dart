import "dart:convert";

import 'package:auth/login.dart';
import 'package:auth/objects/user.dart';
import 'package:auth/widgets/user_form.dart';
import 'package:auth/widgets/snackbar.dart';
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  User user = User("", "");
  Uri url = Uri.parse("http://10.0.2.2:8080/user/register");

  Future save() async {
    var response = await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: json
            .encode({"username": user.username, "password": user.password}));
    if (response.statusCode == 200) {
      snackbar(context, "Account created, you can now log in");
      Navigator.pop(context);
    } else {
      snackbar(context, "An error occurred: " + response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child:
                  userForm(context, "register", save, user, formKey, Login())),
        ));
  }
}
