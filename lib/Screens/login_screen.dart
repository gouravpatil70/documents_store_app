import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/custom_button.dart';
import 'package:documents_store_app/Widgets/custom_input_box.dart';
import 'package:flutter/material.dart';

// Firebase packages
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Required Variables & instances
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _editingEmailIdController = TextEditingController();
  final TextEditingController _editingPasswordController = TextEditingController();

  // Authentication Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Login'),
      body: Center(
        child: Card(
          elevation: 3.0,
          shadowColor: Colors.black,
          margin: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [                  

                  // Top Login Icon UI
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0), 
                    child: CircleAvatar(
                      radius: 45.0,
                      child: Icon(
                        Icons.login,
                        color: Colors.grey[700],
                        size: 40.0,
                      ),
                    ),
                  ),


                  //  For Email
                  CustomTextFormField(validator: 'Please provide Email Id', labelText: 'Email Id', icon: Icons.email_outlined, isPasswordField: false, editingController: _editingEmailIdController, callBack: _onChangedNameValue),
              
                  // For Password
                  CustomTextFormField(validator: 'Please provide Password', labelText: 'Password', icon: Icons.password_outlined, isPasswordField: true, editingController: _editingPasswordController, callBack: _onChangedPasswordValue),
              
                  // Register Button
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: CustomButton.customOutlinedButton(context: context, buttonText: 'Register', callBack: _loginButtonCallBack),
                  ),
              
                  // Register new user 
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: const Text(
                        "Don't have an Account ?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic
                        ),
                        textAlign: TextAlign.right,
                      ),

                      // On Click Event
                      onTap: ()=> _navigateToRegisterScreen(),
                    ),
                  ),

                  // You can add other widets here ...
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Check Authentication
  checkAuthentication(){
    _auth.authStateChanges().listen((user) { 
      if(user != null){
        if(mounted){
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    });
  }

  // For Email Id
  _onChangedNameValue(String input){
    setState(() {
      _editingEmailIdController.text = input.trim();
    });
  }

  // For Password
  _onChangedPasswordValue(String input){
    setState(() {
      _editingPasswordController.text = input.trim();
    });
  }

  // Navigate To Register User Screen
  _navigateToRegisterScreen(){
    Navigator.pushReplacementNamed(context, '/regiserScreen');
  }

  // Login Button Functionality
  _loginButtonCallBack()async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      try{
        await _auth.signInWithEmailAndPassword(email: _editingEmailIdController.text, password: _editingPasswordController.text);
      }catch(e){
        _showErrorMessage(e.toString());
      }
    }
  }

  // Showing an Dialog Box
  _showErrorMessage(String message){
    CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
  }

}
