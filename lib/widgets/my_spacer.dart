import 'package:flutter/cupertino.dart';

class MySpacer extends StatelessWidget {
  final double width;
  final double height;

  MySpacer.horizontal(this.width) : height=0;
  MySpacer.vertical(this.height) : width=0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      width: width,
      height: height,
    );
  }
}
