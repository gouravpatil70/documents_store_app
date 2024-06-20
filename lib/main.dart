import 'package:documents_store_app/Screens/home_screen.dart';
import 'package:documents_store_app/Screens/login_screen.dart';
import 'package:documents_store_app/Screens/register_screen.dart';
import 'package:documents_store_app/Screens/view_document_screen.dart';
import 'package:flutter/material.dart';
import 'package:documents_store_app/Screens/upload_documents_screen.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true
      ),
      home: const HomeScreen(),

      // Defining routes
      routes: <String,WidgetBuilder>{
        '/loginScreen': (BuildContext context)=> const LoginScreen(),
        '/regiserScreen': (BuildContext context)=> const RegisterScreen(),
        '/uploadDocument': (BuildContext context)=> const UploadDocuments(),
        '/viewDocument': (BuildContext context)=> const ViewDocument(),
      },
    );
  }
}