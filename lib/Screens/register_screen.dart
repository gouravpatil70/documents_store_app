import 'package:documents_store_app/Model/UserDetailsModel.dart';
import 'package:documents_store_app/Screens/home_screen.dart';
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/custom_button.dart';
import 'package:documents_store_app/Widgets/custom_input_box.dart';
import 'package:flutter/material.dart';

// Firebase Package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Requried Variables & instances
  final TextEditingController _editingNameController = TextEditingController();
  final TextEditingController _editingEmailIdController = TextEditingController();
  final TextEditingController _editingPasswordController = TextEditingController();
  
  // Firebase Authetication Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Firebsae Firestore Database Instance
  final FirebaseFirestore _firestoreDatabase = FirebaseFirestore.instance;

  // Instance of userDetilsModel
  final UserDetailsModel _userDetailsObject = UserDetailsModel.initializeWithEmptyValues();
  
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Register User'),
      
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(10.0),
          elevation: 3.0,
          shadowColor: Colors.black,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
            
                  // Register UI Icon
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: CircleAvatar(
                      radius: 45.0,
                      child: Icon(
                        Icons.person_add_alt,
                        color: Colors.grey[700],
                        size: 40.0,
                      ),
                    ),
            
                  ),
            
                  // Name Field
                  CustomTextFormField(validator: 'Please provide name', labelText: 'Name', icon: Icons.person_2_outlined, isPasswordField: false, editingController: _editingNameController, callBack: _onChangedNameValue),
            
                  // Email Field
                  CustomTextFormField(validator: 'Please provide Email Id', labelText: 'Email Id', icon: Icons.mail_outline, isPasswordField: false,editingController: _editingEmailIdController, callBack: _onChangedEmailIdValue),
            
                  // Password Field
                  CustomTextFormField(validator: 'Please enter Password', labelText: 'Password', icon: Icons.password_outlined, isPasswordField: true, editingController: _editingPasswordController, callBack: _onChangedPasswordValue),
            
                  // Register Button
                  CustomButton.customOutlinedButton(context: context, buttonText: 'Register Me', callBack: _registerButtonCallBack),
            
                  // If Account Exist text
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: const Text(
                        'Already have an Account ?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      
                      // OnClick event
                      onTap: ()=> _navigateToLoginScreen(),
                    ),
                  ),
            
            
                  // You can add other widgets from here ...
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // For Name
  _onChangedNameValue(String input){
    setState(() {
      _editingNameController.text = input.trim();
      // Storing data inside the UserDetailsModel
      _userDetailsObject.userName = input.trim();
    });
  }

  // For EmailId
  _onChangedEmailIdValue(String input){
    setState(() {
      _editingEmailIdController.text = input.trim();
      // Storing data inside the UserDetailsModel
      _userDetailsObject.userEmailId = input.trim();
    });
  }
  // For Password
  _onChangedPasswordValue(String input){
    setState(() {
      _editingPasswordController.text = input.trim();
      // Storing data inside the UserDetailsModel
      _userDetailsObject.userPassword = input.trim();
    });
  }

  // Navigate to Login Screen
  _navigateToLoginScreen(){
    Navigator.pushReplacementNamed(context, '/loginScreen');
  }

  // Register Button Functionality
  _registerButtonCallBack()async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      try{
        // Creating an new Authentication Account
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _editingEmailIdController.text, password: _editingPasswordController.text);
        // Upadating the userProfile
        if(userCredential.user != null){
          userCredential.user?.updateProfile(
            displayName: _editingNameController.text,
          );
        }

        // Uploading the data into firestore database
        await _firestoreDatabase.collection('userDetails').doc(_userDetailsObject.userEmailId).set(_userDetailsObject.toJson());

        _navigateToHomeScreen();
      }catch(e){
        _showErrorMessage(e.toString());
      }
    }
  }

  // Showing an alertDialog Box
  _showErrorMessage(String message){
    CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
  }

  _navigateToHomeScreen(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (BuildContext context){
        return const HomeScreen();
      }), (route) => false);
  }
}