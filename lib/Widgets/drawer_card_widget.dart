import 'package:flutter/material.dart';

class DrawerCardChildren{
  static GestureDetector customDrawerCardWidget({required BuildContext context, required String cardTitle, required IconData cardIcon}){
    return GestureDetector(
      child: Card(
        elevation: 2.5,
        shadowColor: Colors.black,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0)
          ),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardTitle,
                style: const TextStyle(
                  fontSize: 17.0
                ),
              ),
              Icon(cardIcon)
            ],
          ),
        ),
      ),
    );
  }
}