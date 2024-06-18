import 'package:flutter/material.dart';

class CustomAppBar{
  static customAppBar({required BuildContext context, required String appTitle, required}){
    return AppBar(
      title: Text(appTitle),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      elevation: 3.0,
      shadowColor: Colors.black,
    );
  }
}