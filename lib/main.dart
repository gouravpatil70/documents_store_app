import 'package:documents_store_app/Screens/login_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Document Storing Applicaton',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true
      ),
      home: const LoginScreen(),
    );
  }
}