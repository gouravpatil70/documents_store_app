import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/custom_button.dart';
import 'package:documents_store_app/Widgets/custom_input_box.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _globakKey = GlobalKey();
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
              key: _globakKey,
              child: Column(
                children: [                  

                  // Top Login Icon UI
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0), 
                    child: CircleAvatar(
                      radius: 45.0,
                      child: Icon(
                        Icons.login,
                        size: 40.0,
                      ),
                    ),
                  ),


                  //  For Email
                  const CustomTextFormField(validator: 'Please provide Email Id', icon: Icons.email_outlined, isPasswordField: false),
              
                  // For Password
                  const CustomTextFormField(validator: 'Please provide Password', icon: Icons.password_outlined, isPasswordField: true),
              
                  // Register Button
                  CustomButton.customOutlinedButton(context: context, buttonText: 'Register'),
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
