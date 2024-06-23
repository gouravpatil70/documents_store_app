import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documents_store_app/Model/DocumentMode.dart';
import 'package:documents_store_app/Screens/home_screen.dart';
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/custom_button.dart';
import 'package:documents_store_app/Widgets/custom_input_box.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// Firebase packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadDocuments extends StatefulWidget {
  final User user;
  const UploadDocuments({super.key, required this.user});



  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {

  // Requried instances
  final TextEditingController _editingDocumentNameController = TextEditingController();


  // Requried Variables
  File? _document;
  String? _documentName;

  // Firebase Storage reference
  final FirebaseFirestore _cloudStorage = FirebaseFirestore.instance;

  // Instance of the Document model
  final DocumentStoreModel _documentStoreModel = DocumentStoreModel.initializeWithEmptyValues();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Upload Document'),
      body: Center(
        child: Card(
          elevation: 3.0,
          shadowColor: Colors.black,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              
                  // For Document Name
                  CustomTextFormField(validator: 'Please provide document Name', labelText: 'Document Name', icon: Icons.edit_document, isPasswordField: false,editingController: _editingDocumentNameController, callBack: _onChangedDocumentNameValue),
              
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
            
                  CustomButton.customElevatedButton(context: context, buttonText: 'Upload',callBack: _uploadDocumentToDatabase),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  _onChangedDocumentNameValue(String input){
    setState(() {
      _editingDocumentNameController.text = input;

      // Stroing documentName into the Document Model variable
      _documentStoreModel.documentName = input.trim();

    });
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

  // Upload document to cloud storage
  _uploadDocumentToDatabase()async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      
      // Uploading file to storage
      try{
        Reference storageReference = FirebaseStorage.instance.ref().child(_documentName!);
        await storageReference.putFile(_document!).then((firebaseFile)async{
          var downloadUrl = await firebaseFile.ref.getDownloadURL();
          setState(() {
            _documentStoreModel.documentUrl = downloadUrl;
          });
        });

        // Now Upload data into the firestore database. Specifically to users Account
        await _cloudStorage.collection('userDetails').doc(widget.user.email).collection('documents').doc(_documentName).set(_documentStoreModel.toJson(), SetOptions(merge: true));

        bool resultOfAlertDialog = await _showErrorMessage('File uploaded successfully');

        if(resultOfAlertDialog){
          Timer(const Duration(milliseconds: 500),(){
            _navigateToHomeScreen();
          });
        }
      }catch(e){
        _showErrorMessage(e.toString());
      }
    }
  }


  // Navigate to Home Screen
  _navigateToHomeScreen(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
      return const HomeScreen();
    }), (route) => false);
  }
  
  Future<bool> _showErrorMessage(String message)async{
    bool result = await CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
    return result;
  }
}

