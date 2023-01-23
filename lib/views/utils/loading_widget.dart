import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingView extends StatelessWidget {
  final String? loadingText;

  const LoadingView({Key? key, this.loadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const CircularProgressIndicator(),
            SizedBox(
              height: 20.h,
            ),
            Text(loadingText??'Loading... Please wait...'),
          ],
        ),
      ),
    );
  }
}
