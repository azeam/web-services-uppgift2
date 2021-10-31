import 'package:auth/helpers/token_helper.dart';
import 'package:auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget menuDrawer(context) {
  return Drawer(
      child: ListView(children: [
    ListTile(
      title: const Text("Log out"),
      trailing: const Icon(Icons.logout),
      onTap: () async {
        await deleteToken();
        Navigator.pop(context);
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Login(),
            ));
      },
    )
  ]));
}
