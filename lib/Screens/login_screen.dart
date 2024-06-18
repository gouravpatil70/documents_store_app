import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Login')
    );
  }
}