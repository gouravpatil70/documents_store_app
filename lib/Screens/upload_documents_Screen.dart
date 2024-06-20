import 'dart:async';

import 'package:documents_store_app/Screens/home_screen.dart';
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/custom_input_box.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {

  // Requried Variables
  File? _document;
  String? _documentName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Upload Document'),
      body: Center(
        child: Card(
          elevation: 3.0,
          shadowColor: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                // For Document Name
                const CustomTextFormField(validator: 'Please provide document Name', labelText: 'Document Name', icon: Icons.edit_document, isPasswordField: false),
            
                // Selecting document from the gallery
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 80, 164, 232),
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          _documentName != null ? _documentName! : 'Select Document',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    onTap: ()=>_pickFileFromStorage(),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: ElevatedButton(
                    onPressed: ()=>_uploadDocumentToDatabase(), 
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Upload',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Selecting document from the gallery
  _pickFileFromStorage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      setState(() {
        _document = file;
        _documentName = fileName;
      });
    }
  }

  // upload document to cloud storage
  _uploadDocumentToDatabase()async{
    bool resultOfAlertDialog = await CustomAlertDialog.customAelrtDialogBox(context: context, message: 'Document Successfully Uploaded');

    if(resultOfAlertDialog){
      Timer(const Duration(milliseconds: 500),(){
        _navigateToHomeScreen();
      });
    }
  }


  // Navigate to Home Screen
  _navigateToHomeScreen(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
      return const HomeScreen();
    }), (route) => false);
  }
  
}

