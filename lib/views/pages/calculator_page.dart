import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/views/views/calculator_view.dart';

import '../../viewmodels/blocs/calculator/calculator_bloc.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalculatorBloc>(
      create: (context) => CalculatorBloc()..add(CalculatorOnLoadEvent(),),
      child: CurrencyCalcView(),
    );
  }
}
