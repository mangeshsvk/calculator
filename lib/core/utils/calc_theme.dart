import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/utils/clac_size.dart';
import 'calc_colors.dart';

class CalcThemes {
  ThemeData calcWhiteTheme = ThemeData(
    appBarTheme:  AppBarTheme(
      color: LightColors.appPrimaryColorDark,
      iconTheme: const IconThemeData(color: LightColors.errorColor),
      elevation: CalcSize.calcSize5.h,
    ),
    errorColor: LightColors.errorColor,
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.black,fontSize: 14.sp,fontWeight: FontWeight.bold),
      headline2: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.bold),
      headline3: TextStyle(color: Colors.black,fontSize: 10.sp,fontWeight: FontWeight.bold),
      button: TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.bold),
    ),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.normal,disabledColor: Colors.grey,buttonColor: Colors.green)

  );
}
