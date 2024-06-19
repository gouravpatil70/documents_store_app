import 'package:flutter/material.dart';


class CustomTextFormField extends StatefulWidget {
  final String validator;
  final IconData icon;
  final bool isPasswordField;
  const CustomTextFormField({super.key, required this.validator, required this.icon, required this.isPasswordField});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

  bool isNotPasswordShow = true;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        validator: (input){
          if(input!.isEmpty){
            return widget.validator;
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(widget.icon),          
          suffixIcon: widget.isPasswordField != false 
          ? GestureDetector(
              child: const Icon(
                Icons.remove_red_eye_outlined,
              ),
              onTap: (){
                setState(() {
                  isNotPasswordShow = !isNotPasswordShow;
                });
              }
            ) 
          : const SizedBox(),
        ),
        obscureText: widget.isPasswordField != false ? isNotPasswordShow : widget.isPasswordField,
        obscuringCharacter: '*',
      ),
    );
  }
}