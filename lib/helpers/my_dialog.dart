import 'package:flutter/material.dart';

class MyDialog {
  // var context;
  // String title;
  // String message;
  // Function function;
  // Function destanation;

  // MyDialog({required this.context, required this.title, required this.message, required this.function, required this.destanation,});

  static void show(BuildContext context, String title, String message) {
    var toast = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return toast;
      },
    );
  }

  static Future<void> showWithDelay(
      BuildContext context, String title, String message) async {
    var toast = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    await Future.delayed(const Duration(seconds: 2));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return toast;
      },
    );
  }

  static void showWidget(BuildContext context, String title, Widget content) {
    var toast = AlertDialog(
        elevation: 20,
        backgroundColor: Colors.white,
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap:
                true, // <-- Set this to true to scale proportionally with dialogs content
            children: [
              content,
            ],
          ),
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return toast;
      },
    );
  }

  static void showProgress(BuildContext context, String title, Widget content) {
    var toast = AlertDialog(
      title: Text(title),
      content: Container(
        alignment: Alignment.center,
        height: 110,
        width: 110,
        child: ListView(
          shrinkWrap: true, // <-- Set this to true
          children: [
            content,
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return toast;
      },
    );
  }

//   Future<void> _ApproveCancelDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: const <Widget>[
//                 Text('Are you sure to logout?'),
//                 Text('You will be lost your current profile.'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Approve'),
//               onPressed: () {
//                 _performLogout();
//                 gotoLoginPage(context, replace: false);
//                 // Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
}
