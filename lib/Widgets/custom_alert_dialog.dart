import 'package:flutter/material.dart';

class CustomAlertDialog{


  static customAelrtDialogBox({required BuildContext context, required String message}){
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(message),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop(true);
              }, 
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              ),
              child: const Text('Ok')
            ),
          ],
        );
      }
    );
  }
}