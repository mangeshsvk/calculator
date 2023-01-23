import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CommonButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback? buttonTapped;

  const CommonButton({Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.buttonTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonTapped,
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 19),
          ),
        ),
      ),
    );
  }
}