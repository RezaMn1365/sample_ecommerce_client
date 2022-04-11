import 'package:flutter/material.dart';

class textValidationWidget extends StatelessWidget {
  dynamic color;
  String text;
  String number;
  double? widgetSize;
  textValidationWidget(
      {Key? key,
      required this.color,
      required this.text,
      required this.number,
      this.widgetSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widgetSize! * 0.08,
          width: widgetSize! * 0.2,
          child: Text(
            number,
            style: TextStyle(fontSize: widgetSize! * 0.05),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          height: 5,
          width: widgetSize! * 0.2,
          color: color,
        ),
        const SizedBox(
          height: 2,
        ),
        SizedBox(
          height: widgetSize! * 0.09,
          width: widgetSize! * 0.2,
          child: Text(
            text,
            style: TextStyle(fontSize: widgetSize! * 0.05),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
