import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/constants/button_names.dart';
import '/core/utils/calc_colors.dart';
import '../../models/currencies.dart';
import '../../viewmodels/blocs/currencies/currency_bloc.dart';
import '../utils/online_status_widget.dart';
import '../views/picker_view.dart';

class PickerWidget extends StatelessWidget {
  final List<CurrencyModel> currencies;
  final CurrencyModel? selectedCurrency;
  final OnItemClick selectCurrencyTap;

  const PickerWidget({
    Key? key,
    required this.currencies,
    required this.selectedCurrency,
    required this.selectCurrencyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Currency Picker'),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.h,
          ),
          const OnlineStatusWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: ListView.builder(
                    itemCount: currencies.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                            color: LightColors.appPrimaryColorLight,
                            child: ListTile(
                                leading: currencies[index] == selectedCurrency
                                    ? const Icon(
                                        Icons.radio_button_checked_outlined,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.radio_button_off),
                                title: Text(
                                  currencies[index].name ?? '',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                subtitle: Text(
                                  currencies[index].desc ?? '',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                onTap: () {
                                  selectCurrencyTap(
                                      currencies[index].name ?? '');
                                }),
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: TextButton(
              onPressed:
                  selectedCurrency == null || selectedCurrency!.name == ''
                      ? null
                      : () {
                          BlocProvider.of<CurrencyBloc>(context).add(
                              CurrencyOnSavedEvent(
                                  selectedCurrency: selectedCurrency == null
                                      ? ''
                                      : selectedCurrency?.name ?? ''));
                        },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      LightColors.appPrimaryColorDark)),
              child: Text(
                ButtonNames.selectCurrencyButton,
                style: TextStyle(
                    color: LightColors.buttonTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
