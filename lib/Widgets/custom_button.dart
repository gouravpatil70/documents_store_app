import 'package:flutter/material.dart';

class CustomButton{
  static OutlinedButton customOutlinedButton({required BuildContext context, required String buttonText, required Function callBack}){
    return OutlinedButton(
      onPressed: ()=>callBack(),
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

  static ElevatedButton customElevatedButton({required BuildContext context, required String buttonText, required Function callBack}){
    return ElevatedButton(
      onPressed: ()=>callBack(), 
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
        ),
      )
    );
  }
}