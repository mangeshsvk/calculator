import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/views/utils/loading_widget.dart';
import '../../viewmodels/blocs/currencies/currency_bloc.dart';
import '../pages/calculator_page.dart';
import '../utils/error_widget.dart';
import '../widgets/picker_widget.dart';

typedef OnItemClick = void Function(String symbolId);

class CurrencyPickerView extends StatelessWidget {
  const CurrencyPickerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrencyBloc, CurrencyState>(
      listener: (context, state) {
        if(state is CurrencyOnSavedState){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> CalculatorPage()));
        }
      },
      builder: (context, state) {
        if (state is CurrencyOnLoadState) {
          return PickerWidget(
            currencies: state.currencies,
            selectedCurrency: state.selectedCurrency,
            selectCurrencyTap: (value) {
              BlocProvider.of<CurrencyBloc>(context).add(CurrencyOnUpdateEvent(
                  currencies: state.currencies, selectedCurrency: value));
            },
          );
        } else if (state is CurrencyErrorState) {
          return ErrorView(
            error: state.error,
            onRetry: () {
              BlocProvider.of<CurrencyBloc>(context)
                  .add(const CurrencyOnLoadEvent(currentCurrencySymbol: ''));
            },
          );
        } else {
          return const LoadingView();
        }
      },
    );
  }
}
