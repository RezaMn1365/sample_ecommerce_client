import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String item) {
 var snackbar = const SnackBar(
     content: Text('..............',
   style: TextStyle(fontSize: 15),
 ));
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
   content: Text('The $item Web service is not avaliable now.'),
   duration: const Duration(seconds: 2),
  //  action: SnackBarAction(
  //  label: 'Undo', 
  //  onPressed: (){
  //    debugPrint('Undo Pressed!');
  //    }),
 ));
}