import 'dart:async';
import '../../../core/constants/storage_keys.dart';
import '../../../models/currency_rate_model.dart';
import '/core/enums/mathematical_expressions.dart';
import '/repositories/currencyRatesRepository/currency_rates_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'calculator_event.dart';

part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final sharedPref = GetIt.I<SharedPreferences>();
  final conversionRepo = GetIt.I<CurrencyRatesRespository>();

  CalculatorBloc() : super(CalculatorInitial()) {
    on<CalculatorOnLoadEvent>(_onLoadState);
    on<CalculatorOnUpdateEvent>(_onUpdateState);
    on<CalculatorOnResetEvent>(_onResetState);
    on<CalculatorOnCalculateEvent>(_onCalculateState);
  }

  FutureOr<void> _onLoadState(
      CalculatorOnLoadEvent event, Emitter<CalculatorState> emit) async {
    emit(CalculatorLoadingState());
    final data = await conversionRepo.getCurrencyRate();
    final outputCurrency = sharedPref.getString(StorageKeys.outputCurrency);
    if (data.error == null || data.success == false) {
      List<CurrencyRateModel>? conversionRate = data.rates == null
          ? []
          : data.rates?.entries
              .map((entry) =>
                  CurrencyRateModel(name: entry.key, value: entry.value))
              .toList();
      emit(CalculatorOnLoadState(
          conversionRates: conversionRate ?? [],
          outputCurrency: outputCurrency ?? '',
          firstValue: null,
          secondValue: null,
          totalValue: null,
          isReset: false,
          operator: MathematicalExpression.Addition));
    } else {
      emit(CalculatorErrorState(error: data.error ?? ''));
    }
  }

  FutureOr<void> _onUpdateState(
      CalculatorOnUpdateEvent event, Emitter<CalculatorState> emit) async {
    emit(CalculatorLoadingState());
    emit(CalculatorOnLoadState(
      conversionRates: event.conversionRates,
      outputCurrency: event.outputCurrency,
      firstCurrency: event.firstCurrency,
      firstValue: event.firstValue,
      secondCurrency: event.secondCurrency,
      secondValue: event.secondValue,
      operator: event.operator,
      resetKey: event.resetKey,
      arithmeticError: event.arithmeticError,
      totalValue: null,
      isReset: false
    ));
  }

  FutureOr<void> _onResetState(
      CalculatorOnResetEvent event, Emitter<CalculatorState> emit) async {
    emit(CalculatorLoadingState());
    final data = await conversionRepo.getCurrencyRate();
    final outputCurrency = sharedPref.getString(StorageKeys.outputCurrency);
    if (data.error == null || data.success == false) {
      List<CurrencyRateModel>? conversionRate = data.rates == null
          ? []
          : data.rates?.entries
          .map((entry) =>
          CurrencyRateModel(name: entry.key, value: entry.value))
          .toList();
      emit(CalculatorOnLoadState(
          conversionRates: conversionRate ?? [],
          outputCurrency: outputCurrency ?? '',
          firstValue: null,
          secondValue: null,
          isReset: true,
          resetKey: DateTime.now().toIso8601String(),
          operator: MathematicalExpression.Addition));
    } else {
      emit(CalculatorErrorState(error: data.error ?? ''));
    }
  }

  FutureOr<void> _onCalculateState(
      CalculatorOnCalculateEvent event, Emitter<CalculatorState> emit) async {
    double firstValue = 0.0;
    double secondValue = 0.0;
    double totalValue = 0.0;
    firstValue = normaliseValues(
      base: event.base ?? '',
      outputCurrency: event.outputCurrency,
      conversions: event.conversionRates,
      currencyKey: event.firstCurrency ?? '',
      currencyValue: double.parse(event.firstValue ?? ''),
    );
    secondValue = normaliseValues(
      base: event.base ?? '',
      outputCurrency: event.outputCurrency,
      conversions: event.conversionRates,
      currencyKey: event.secondCurrency ?? '',
      currencyValue: double.parse(event.secondValue ?? ''),
    );

    String? arithmeticError;

    switch (event.operator) {
      case MathematicalExpression.Addition:
        totalValue = firstValue + secondValue;
        break;
      case MathematicalExpression.Subtraction:
        totalValue = firstValue - secondValue;
        break;
      case MathematicalExpression.Division:
        try {
          totalValue = (firstValue / (secondValue));
        } catch (e) {
          arithmeticError = e.toString();
        }
        break;
      case MathematicalExpression.Multiplication:
        totalValue = (firstValue * secondValue);
        break;
        default:
          totalValue = firstValue + secondValue;
          break;
    }

    emit(CalculatorOnLoadState(
      outputCurrency: event.outputCurrency,
      conversionRates: event.conversionRates,
      totalValue: totalValue,
      arithmeticError: arithmeticError,
      operator: event.operator,
      firstCurrency: event.firstCurrency,
      secondCurrency: event.secondCurrency,
      firstValue: event.firstValue,
      resetKey: event.resetKey,
      secondValue: event.secondValue,
      isReset: false
    ));
  }

  double normaliseValues(
      {required String base,
      required String currencyKey,
      required double currencyValue,
      required List<CurrencyRateModel> conversions,
      required String outputCurrency}) {
    final outputCurrencyRate =
        conversions.firstWhere((element) => element.name == outputCurrency).value;
    final currencyRate =
        conversions.firstWhere((element) => element.name == currencyKey).value;
    final normalisedValue =
        ((outputCurrencyRate ?? 0.0) / (currencyRate ?? 0.0)) * currencyValue;
    return normalisedValue;
  }
}
