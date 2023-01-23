part of 'calculator_bloc.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object?> get props => [];
}

class CalculatorInitial extends CalculatorState {}

class CalculatorOnLoadState extends CalculatorState {
  final String outputCurrency;
  final String? firstValue;
  final String? secondValue;
  final String? arithmeticError;
  final double? totalValue;
  final MathematicalExpression? operator;
  final String? firstCurrency;
  final String? secondCurrency;
  final bool? isReset;
  final String? resetKey;
  final List<CurrencyRateModel> conversionRates;

  const CalculatorOnLoadState({
    required this.outputCurrency,
    required this.conversionRates,
    this.firstValue,
    this.secondValue,
    this.arithmeticError,
    this.totalValue,
    this.operator,
    this.firstCurrency,
    this.secondCurrency,
    this.isReset,
    this.resetKey,
  });

  @override
  List<Object?> get props => [
        outputCurrency,
        firstCurrency,
        firstValue,
        secondCurrency,
        secondValue,
        arithmeticError,
        totalValue,
        isReset,
        operator,
        conversionRates,
      ];
}

class CalculatorWithNoExchangeDataState extends CalculatorState {}

class CalculatorErrorState extends CalculatorState {
  final String? error;

  const CalculatorErrorState({required this.error});
}

class CalculatorSuccessState extends CalculatorState {}

class CalculatorLoadingState extends CalculatorState {}
