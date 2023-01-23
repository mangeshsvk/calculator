part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();
  @override
  List<Object?> get props => [];
}

class CalculatorOnLoadEvent extends CalculatorEvent{
}

class CalculatorOnResetEvent extends CalculatorEvent{}
class CalculatorOnUpdateEvent extends CalculatorEvent{
  final String outputCurrency;
  final String? firstValue;
  final String? secondValue;
  final String? arithmeticError;
  final double? totalValue;
  final MathematicalExpression? operator;
  final String? firstCurrency;
  final String? secondCurrency;
  final String? resetKey;
  final List<CurrencyRateModel> conversionRates;

  const CalculatorOnUpdateEvent({
    required this.outputCurrency,
    required this.conversionRates,
    this.firstValue,
    this.secondValue,
    this.arithmeticError,
    this.totalValue,
    this.resetKey,
    this.operator,
    this.firstCurrency,
    this.secondCurrency,
  });

  @override
  List<Object?> get props => [
    outputCurrency,
    firstCurrency,
    firstValue,
    secondCurrency,
    secondValue,
    resetKey,
    arithmeticError,
    totalValue,
    operator,
    conversionRates
  ];
}

class CalculatorOnCalculateEvent extends CalculatorEvent{
  final String outputCurrency;
  final String? firstValue;
  final String? base;
  final String? secondValue;
  final String? arithmeticError;
  final double? totalValue;
  final MathematicalExpression? operator;
  final String? firstCurrency;
  final String? resetKey;
  final String? secondCurrency;
  final List<CurrencyRateModel> conversionRates;

  const CalculatorOnCalculateEvent({
    required this.outputCurrency,
    required this.conversionRates,
    this.firstValue,
    this.base,
    this.secondValue,
    this.resetKey,
    this.arithmeticError,
    this.totalValue,
    this.operator,
    this.firstCurrency,
    this.secondCurrency,
  });

  @override
  List<Object?> get props => [
    outputCurrency,
    firstCurrency,
    firstValue,
    base,
    resetKey,
    secondCurrency,
    secondValue,
    arithmeticError,
    totalValue,
    operator,
    conversionRates
  ];
}