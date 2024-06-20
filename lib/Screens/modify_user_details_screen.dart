import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/custom_button.dart';
import 'package:documents_store_app/Widgets/custom_input_box.dart';
import 'package:flutter/material.dart';
class ModifyUserDetails extends StatefulWidget {
  const ModifyUserDetails({super.key});

  @override
  State<ModifyUserDetails> createState() => _ModifyUserDetailsState();
}

class _ModifyUserDetailsState extends State<ModifyUserDetails> {

  // Form Key
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _editingNameController = TextEditingController();
  final TextEditingController _editingEmailIdController = TextEditingController();
  final TextEditingController _editingPasswordController = TextEditingController();

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
                  CustomTextFormField(validator: 'Please provide Name', labelText: 'Name', icon: Icons.person, isPasswordField: false, editingController: _editingNameController,callBack: _onChangedNameValue),
                  
                  // Email Id Field
                  CustomTextFormField(validator: 'Please provide Email Id', labelText: 'Email Id', icon: Icons.email_outlined, isPasswordField: false, editingController: _editingEmailIdController,callBack: _onChangedEmailValue),

                  // Password Field
                  CustomTextFormField(validator: 'Please enter Passwrod', labelText: 'Password', icon: Icons.password_outlined, isPasswordField: true, editingController: _editingPasswordController,callBack: _onChangedPasswordValue),

                  // Modify Button 
                  CustomButton.customElevatedButton(context: context, buttonText: 'Modify'),
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
      _editingNameController.text = input;
    });
  }

  // For Email
  _onChangedEmailValue(String input){
    setState(() {
      _editingEmailIdController.text = input;
    });
  }

  // For Password
  _onChangedPasswordValue(String input){
    setState(() {
      _editingPasswordController.text = input;
    });
  }
}