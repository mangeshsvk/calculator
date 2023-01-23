import 'package:flutter/material.dart';
import '/core/enums/mathematical_expressions.dart';
import '/core/utils/calc_colors.dart';
import '/models/currency_rate_model.dart';
import '/views/pages/picker_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/input_labels.dart';
import '../../viewmodels/blocs/calculator/calculator_bloc.dart';
import '../utils/common_button.dart';
import '../utils/currency_dropdown.dart';
import '../utils/input_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/online_status_widget.dart';

class CalculatorWidget extends StatelessWidget {
  final String outputCurrency;
  final String? firstValue;
  final String? secondValue;
  final String? firstCurrency;
  final String? secondCurrency;
  final MathematicalExpression? operation;
  final String? arithmeticError;
  final double? totalValue;
  final bool? isReset;
  final String? resetKey;
  final List<CurrencyRateModel> currencyRates;

  const CalculatorWidget({
    Key? key,
    required this.outputCurrency,
    required this.currencyRates,
    this.isReset,
    this.firstValue,
    this.secondValue,
    this.firstCurrency,
    this.resetKey,
    this.secondCurrency,
    this.operation,
    this.arithmeticError,
    this.totalValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Currency Calculator'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 0.85.sh,
          width: 1.sw,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.topRight,
                        child: OnlineStatusWidget()),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: InputField(
                            key: Key(resetKey ?? ''),
                            labelText: InputLabels.firstInputCalculatorWidget,
                            initialText: firstValue,
                            onChanged: (String value) {
                              BlocProvider.of<CalculatorBloc>(context)
                                  .add(CalculatorOnUpdateEvent(
                                outputCurrency: outputCurrency,
                                firstValue: value,
                                secondValue: secondValue,
                                secondCurrency: secondCurrency,
                                operator: operation,
                                firstCurrency: firstCurrency,
                                conversionRates: currencyRates,
                                arithmeticError: arithmeticError,
                                resetKey: resetKey,
                                totalValue: totalValue,
                              ));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)),
                                  border: Border.all(color: Colors.grey)),
                              child: CurrencyDropdown(
                                conversions: currencyRates,
                                hintText: firstCurrency ??
                                    DropdownLabels.currencyDropdown,
                                selectCurrencyTap: (String currency) {
                                  BlocProvider.of<CalculatorBloc>(context)
                                      .add(CalculatorOnUpdateEvent(
                                    outputCurrency: outputCurrency,
                                    firstValue: firstValue,
                                    secondValue: secondValue,
                                    secondCurrency: secondCurrency,
                                    operator: operation,
                                    firstCurrency: currency,
                                    resetKey: resetKey,
                                    conversionRates: currencyRates,
                                    arithmeticError: arithmeticError,
                                    totalValue: totalValue,
                                  ));
                                },
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: InputField(
                            key: Key(resetKey ?? ''),
                            labelText: InputLabels.secondInputCalculatorWidget,
                            initialText: secondValue,
                            onChanged: (String value) {
                              BlocProvider.of<CalculatorBloc>(context)
                                  .add(CalculatorOnUpdateEvent(
                                outputCurrency: outputCurrency,
                                firstValue: firstValue,
                                secondValue: value,
                                secondCurrency: secondCurrency,
                                operator: operation,
                                firstCurrency: firstCurrency,
                                conversionRates: currencyRates,
                                resetKey: resetKey,
                                arithmeticError: arithmeticError,
                                totalValue: totalValue,
                              ));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)),
                                  border: Border.all(color: Colors.grey)),
                              child: CurrencyDropdown(
                                conversions: currencyRates,
                                hintText: secondCurrency ??
                                    DropdownLabels.currencyDropdown,
                                selectCurrencyTap: (currency) {
                                  BlocProvider.of<CalculatorBloc>(context)
                                      .add(CalculatorOnUpdateEvent(
                                    outputCurrency: outputCurrency,
                                    firstValue: firstValue,
                                    secondValue: secondValue,
                                    secondCurrency: currency,
                                    operator: operation,
                                    resetKey: resetKey,
                                    firstCurrency: firstCurrency,
                                    conversionRates: currencyRates,
                                    arithmeticError: arithmeticError,
                                    totalValue: totalValue,
                                  ));
                                },
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                          MathematicalExpression.values.length, (index) {
                        return ChoiceChip(
                          backgroundColor: Colors.black12,
                          labelPadding: EdgeInsets.all(2.0.w),
                          label: Text(
                            MathematicalExpression.values[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          selected: (operation) ==
                              MathematicalExpression.values[index],
                          selectedColor: LightColors.appPrimaryColorDark,
                          onSelected: (value) {
                            BlocProvider.of<CalculatorBloc>(context)
                                .add(CalculatorOnUpdateEvent(
                              outputCurrency: outputCurrency,
                              firstValue: firstValue,
                              secondValue: secondValue,
                              secondCurrency: secondCurrency,
                              operator: MathematicalExpression.values[index],
                              firstCurrency: firstCurrency,
                              conversionRates: currencyRates,
                              resetKey: resetKey,
                              arithmeticError: arithmeticError,
                              totalValue: totalValue,
                            ));
                          },
                          // backgroundColor: color,
                          elevation: 1,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const PickerPage()));
                      },
                      child: Card(
                        color: LightColors.appPrimaryColorDark,
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              Text(
                                'Output Currency is: ($outputCurrency)',
                                style: Theme.of(context).textTheme.button!.copyWith(color: LightColors.buttonTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: arithmeticError != null ? true : false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Error: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        Expanded(
                            child: Text(
                          arithmeticError ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        )),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: totalValue != null ? true : false,
                    child: Text(
                      '\nTotal : ${totalValue?.toStringAsFixed(2)} $outputCurrency',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            text: 'Reset',
                            buttonTapped: () {
                              BlocProvider.of<CalculatorBloc>(context)
                                  .add(CalculatorOnResetEvent());
                            }),
                      ),
                      Expanded(
                        child: CommonButton(
                            color: !validator() ? Colors.grey : Colors.green,
                            textColor: Colors.white,
                            text: 'Calculate',
                            buttonTapped: !validator()
                                ? null
                                : () {
                                    BlocProvider.of<CalculatorBloc>(context)
                                        .add(CalculatorOnCalculateEvent(
                                      outputCurrency: outputCurrency,
                                      firstValue: firstValue,
                                      secondValue: secondValue,
                                      secondCurrency: secondCurrency,
                                      operator: operation,
                                      resetKey: resetKey,
                                      firstCurrency: firstCurrency,
                                      conversionRates: currencyRates,
                                      arithmeticError: arithmeticError,
                                      totalValue: totalValue,
                                    ));
                                  }),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validator() {
    if (firstCurrency == null ||
        secondCurrency == null ||
        firstValue == null ||
        secondValue == null ||
        operation == null) {
      return false;
    } else {
      return true;
    }
  }
}
