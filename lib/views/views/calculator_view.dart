import 'package:flutter/material.dart';
import '/views/utils/error_widget.dart';
import '/views/utils/loading_widget.dart';
import '/views/widgets/calculator_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/blocs/calculator/calculator_bloc.dart';

class CurrencyCalcView extends StatelessWidget {
  const CurrencyCalcView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        if (state is CalculatorOnLoadState) {
          return CalculatorWidget(
            outputCurrency: state.outputCurrency,
            currencyRates: state.conversionRates,
            firstCurrency: state.firstCurrency,
            secondCurrency: state.secondCurrency,
            firstValue: state.firstValue,
            secondValue: state.secondValue,
            arithmeticError: state.arithmeticError,
            operation: state.operator,
            totalValue: state.totalValue,
            isReset: state.isReset,
            resetKey: state.resetKey,
          );
        }
        if (state is CalculatorErrorState) {
          return ErrorView(
            error: state.error ?? 'Something Went Wrong',
            onRetry: () {
              BlocProvider.of<CalculatorBloc>(context)
                  .add(CalculatorOnLoadEvent());
            },
          );
        } else {
          return const LoadingView();
        }
      },
    );
  }
}
