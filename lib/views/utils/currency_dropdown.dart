import 'package:flutter/material.dart';
import '/models/currency_rate_model.dart';
import '../views/picker_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<CurrencyRateModel> conversions;
  final String hintText;
  final OnItemClick selectCurrencyTap;
  const CurrencyDropdown({Key? key, required this.conversions, required this.hintText, required this.selectCurrencyTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal:8.w),
        child: DropdownButton<CurrencyRateModel>(
          isExpanded: true,
          hint: Text(hintText,style: Theme.of(context).textTheme.headline2,),
          underline: Container(
              color: Colors.transparent),
          items: conversions
              .map((value) {
            return DropdownMenuItem<
                CurrencyRateModel>(
              value: value,
              child: Column(
                children: [
                  Text(value.name??''),
                  const Divider(),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            selectCurrencyTap(newValue!.name??'');
          },
        ),
      ),
    );
  }
}
