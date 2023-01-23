import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const ErrorView({Key? key, required this.error, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error),
            SizedBox(height: 20.h,),
            TextButton(onPressed: onRetry, child: const Text('Retry')),

          ],
        ),
      ),
    );
  }
}
