import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/views/views/picker_view.dart';

import '../../viewmodels/blocs/currencies/currency_bloc.dart';

class PickerPage extends StatelessWidget {
  const PickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyBloc>(
      create: (context) => CurrencyBloc()..add(const CurrencyOnLoadEvent(currentCurrencySymbol: ''),),
      child:  CurrencyPickerView(),
    );
  }
}
