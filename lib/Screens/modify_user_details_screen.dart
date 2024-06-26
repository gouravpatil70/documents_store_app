import 'dart:async';
import 'package:documents_store_app/Model/UserDetailsModel.dart';
import 'package:documents_store_app/Screens/home_screen.dart';
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/custom_button.dart';
import 'package:documents_store_app/Widgets/custom_input_box.dart';
import 'package:flutter/material.dart';

// Firebase Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModifyUserDetails extends StatefulWidget {
  final User user;
  const ModifyUserDetails({super.key, required this.user});

  @override
  State<ModifyUserDetails> createState() => _ModifyUserDetailsState();
}

class _ModifyUserDetailsState extends State<ModifyUserDetails> {

  // Form Key
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _editingNameController = TextEditingController();
  final TextEditingController _editingEmailIdController = TextEditingController();
  final TextEditingController _editingPasswordController = TextEditingController();

  // Required fields or attributes
  bool? _isLoading;
  bool? _isDataModified;


  // Updating the _auth display Name
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Creating instance of the firestore database
  final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;
  String? _userEmailIdFromAuth;

  // Create an instance of the UserDetailsModel 
  final UserDetailsModel _userDetailsModel = UserDetailsModel.initializeWithEmptyValues();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isDataModified = false;
    _userEmailIdFromAuth = widget.user.email;
    _getUserDetailsForModification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Modify Details'),
      body: Center(
        child: Card(
          elevation: 3.0,
          shadowColor: Colors.black,
          child: SingleChildScrollView(
            child: Form(
              key: _formState,
              child: Column( 
                children: [

                  // Name Field
                  CustomTextFormField(validator: 'Please provide Name', isInputBoxEnabled: true, labelText: 'Name', icon: Icons.person, isPasswordField: false, editingController: _editingNameController,callBack: _onChangedNameValue),
                  
                  // Email Id Field
                  CustomTextFormField(validator: 'Please provide Email Id', isInputBoxEnabled: false, labelText: 'Email Id', icon: Icons.email_outlined, isPasswordField: false, editingController: _editingEmailIdController,callBack: _onChangedEmailValue),

                  // Password Field
                  CustomTextFormField(validator: 'Please enter Passwrod', isInputBoxEnabled: true, labelText: 'Password', icon: Icons.password_outlined, isPasswordField: true, editingController: _editingPasswordController,callBack: _onChangedPasswordValue),

                  // Modify Button 
                  CustomButton.customElevatedButton(context: context, buttonText: 'Modify',callBack: _modifyUserDetailsCallBack),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Getting the User Details
  _getUserDetailsForModification()async{

    // getting the User Details
    DocumentSnapshot<Map<String,dynamic>> userDetailsSnapshot = await _cloudFirestore.collection('userDetails').doc(_userEmailIdFromAuth).get();

    Map<String, dynamic>? userDetailsData = userDetailsSnapshot.data();

    if(userDetailsData != null){
      // Stroing values to the User Model attributes
      _userDetailsModel.userName = userDetailsData['userName'];
      _userDetailsModel.userEmailId = userDetailsData['userEmailId'];
      _userDetailsModel.userPassword = userDetailsData['userPassword'];

      // Adding values to the textEditingController
      setState(() {
        _editingNameController.text = userDetailsData['userName'];
        _editingEmailIdController.text = userDetailsData['userEmailId'];
        _editingPasswordController.text = userDetailsData['userPassword'];

        // Turning off the isLoading
        _isLoading = false;
      });
    }
  }

  // For Name
  _onChangedNameValue(String input){
    setState(() {
      _editingNameController.text = input;

      // Updating the User Model name attribute
      _userDetailsModel.userName = input.trim();

      // Check Condition if data modified
      _isDataModified = true;
    });
  }

  // For Email
  _onChangedEmailValue(String input){
    // setState(() {
    //   _editingEmailIdController.text = input;

    //   // Updating the User Model email attribute
    //   _userDetailsModel.userEmailId = input.trim();

    //   // Check Condition if data modified
    //   _isDataModified = true;
    // });
  }

  // For Password
  _onChangedPasswordValue(String input){
    setState(() {
      _editingPasswordController.text = input;

      // Updating the User Model password attribute
      _userDetailsModel.userPassword = input.trim();

      // Check Condition if data modified
      _isDataModified = true;
    });
  }

  // Modify Details Button
  _modifyUserDetailsCallBack()async{

    // Work Pending Upladingj the details
    if(_isDataModified!){
      try{

        // Updating the database
        await _cloudFirestore.collection('userDetails').doc(_userEmailIdFromAuth).update(_userDetailsModel.toJson());
        
        // Updating the User Display Name Inside the Authentication 
        _auth.authStateChanges().listen((event) {
          event!.updateProfile(
            displayName: _userDetailsModel.userName
          );
        });

        bool resultOfAlertDialog = await _showErrorDialogBox('Details Modified Successfully');
        if(resultOfAlertDialog){
          Timer(const Duration(milliseconds: 500), (){ 
            _navigateToHomeScreen();
          });
        }

      }catch(e){
        _showErrorDialogBox(e.toString());
      }
    }else{
      _showErrorDialogBox('Data Not Modified');
    }
  }

  // Navigate To Home Screen
  _navigateToHomeScreen(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (BuildContext context){
        return const HomeScreen();
      }
    ), (route) => false);
  }

  Future<bool> _showErrorDialogBox(String message)async{
      bool resultOfAlertDialog = await CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
      return resultOfAlertDialog;

  }
}