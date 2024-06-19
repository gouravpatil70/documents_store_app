import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Register User'),
      
    );
  }
}