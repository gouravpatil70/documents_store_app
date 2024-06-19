import 'package:flutter/material.dart';

class CustomButton{
  static OutlinedButton customOutlinedButton({required BuildContext context, required String buttonText}){
    return OutlinedButton(
      onPressed: (){}, 
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
        )
      ),
      child: Text(buttonText)
    );
  }
}