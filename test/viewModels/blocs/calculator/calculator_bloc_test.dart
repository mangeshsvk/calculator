import 'package:calculator/core/enums/mathematical_expressions.dart';
import 'package:calculator/models/currency_rate_model.dart';
import 'package:calculator/models/currency_rates.dart';
import 'package:calculator/repositories/currencyRatesRepository/currency_rates_repository.dart';
import 'package:calculator/viewmodels/blocs/calculator/calculator_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_test/bloc_test.dart';

class _MockCurrencyRatesRespository extends Mock implements CurrencyRatesRespository {}

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late _MockCurrencyRatesRespository mockCurrencyRatesRespository;
  late _MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockCurrencyRatesRespository = _MockCurrencyRatesRespository();
    mockSharedPreferences = _MockSharedPreferences();
    GetIt.I.registerSingleton<CurrencyRatesRespository>(mockCurrencyRatesRespository);
    GetIt.I.registerSingleton<SharedPreferences>(mockSharedPreferences);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('On Load Event: Calculator Bloc tests', () {
    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if Calculator OnLoad Event emits AppOnLoadState',
        setUp: () {
          when(() => mockCurrencyRatesRespository.getCurrencyRate()).thenAnswer(
              (_) => Future.value(const CurrencyRate(
                  success: true,
                  timestamp: 1234,
                  base: '',
                  date: null,
                  error: null,
                  rates: {"AED": 1.0, "INR": 21.5})));
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn('INR');
        },
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(CalculatorOnLoadEvent());
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CalculatorOnLoadState(
                outputCurrency: 'INR',
                operator: MathematicalExpression.Addition,
                isReset: false,
                conversionRates: [
                  CurrencyRateModel(name: 'AED', value: null),
                  CurrencyRateModel(name: 'INR', value: null)
                ],
              ));
        });
    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if ErrorState is emitted on receiving error from server',
        setUp: () {
          when(() => mockCurrencyRatesRespository.getCurrencyRate()).thenAnswer(
              (_) => Future.value(const CurrencyRate(
                  success: true,
                  timestamp: null,
                  base: '',
                  date: null,
                  error: 'Something Went Wrong',
                  rates: null)));
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn('INR');
        },
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(CalculatorOnLoadEvent());
        },
        verify: (bloc) {
          expect(bloc.state,
              const CalculatorErrorState(error: 'Something Went Wrong'));
        });
  });

  group('On Update Event: Calculator Bloc tests', () {
    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if Update Event emits On-load state with updated data or not',
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(const CalculatorOnUpdateEvent(
            outputCurrency: 'AED',
            operator: MathematicalExpression.Addition,
            conversionRates: [],
          ));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CalculatorOnLoadState(
                outputCurrency: 'AED',
                operator: MathematicalExpression.Addition,
                isReset: false,
                conversionRates: [],
              ));
        });
  });

  group('Calculator Bloc : Reset Event', () {
    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if OnReset Event emitts AppOnLoadState with resetting all values',
        setUp: () {
          when(() => mockCurrencyRatesRespository.getCurrencyRate()).thenAnswer(
              (_) => Future.value(const CurrencyRate(
                  success: true,
                  timestamp: 1234,
                  base: '',
                  date: null,
                  error: null,
                  rates: {"AED": 1.0, "INR": 21.5})));
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn('INR');
        },
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(CalculatorOnResetEvent());
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CalculatorOnLoadState(
                outputCurrency: 'INR',
                resetKey: null,
                operator: MathematicalExpression.Addition,
                isReset: true,
                conversionRates: [
                  CurrencyRateModel(name: 'AED', value: null),
                  CurrencyRateModel(name: 'INR', value: null)
                ],
              ));
        });
  });
  group('Calculator Bloc: CalculatorOnCalculateEvent', () {
    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if when CalculatorOnCalculateEvent is added, is OnloadState emitted with correct addition in total',
        setUp: () {
          when(() => mockCurrencyRatesRespository.getCurrencyRate()).thenAnswer(
              (_) => Future.value(const CurrencyRate(
                  success: true,
                  timestamp: 1234,
                  base: '',
                  date: null,
                  error: null,
                  rates: {"AED": 1.0, "INR": 21.5})));
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn('INR');
        },
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(const CalculatorOnCalculateEvent(
              outputCurrency: 'INR',
              operator: MathematicalExpression.Addition,
              firstValue: '1',
              firstCurrency: 'INR',
              secondCurrency: 'INR',
              secondValue: '1',
              conversionRates: [
                CurrencyRateModel(name: 'AED', value: 1.0),
                CurrencyRateModel(name: 'INR', value: 21.5),
              ]));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CalculatorOnLoadState(
                outputCurrency: 'INR',
                operator: MathematicalExpression.Addition,
                isReset: false,
                firstValue: '1',
                firstCurrency: 'INR',
                secondCurrency: 'INR',
                secondValue: '1',
                totalValue: 2.0,
                conversionRates: [
                  CurrencyRateModel(name: 'AED', value: null),
                  CurrencyRateModel(name: 'INR', value: null)
                ],
              ));
        });

    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if when CalculatorOnCalculateEvent is added, is OnloadState emitted with correct subtraction in total',
        setUp: () {
          when(() => mockCurrencyRatesRespository.getCurrencyRate()).thenAnswer(
                  (_) => Future.value(const CurrencyRate(
                  success: true,
                  timestamp: 1234,
                  base: '',
                  date: null,
                  error: null,
                  rates: {"AED": 1.0, "INR": 21.5})));
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn('INR');
        },
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(const CalculatorOnCalculateEvent(
              outputCurrency: 'INR',
              operator: MathematicalExpression.Subtraction,
              firstValue: '1',
              firstCurrency: 'INR',
              secondCurrency: 'INR',
              secondValue: '1',
              conversionRates: [
                CurrencyRateModel(name: 'AED', value: 1.0),
                CurrencyRateModel(name: 'INR', value: 21.5),
              ]));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CalculatorOnLoadState(
                outputCurrency: 'INR',
                operator: MathematicalExpression.Subtraction,
                isReset: false,
                firstValue: '1',
                firstCurrency: 'INR',
                secondCurrency: 'INR',
                secondValue: '1',
                totalValue: 0.0,
                conversionRates: [
                  CurrencyRateModel(name: 'AED', value: null),
                  CurrencyRateModel(name: 'INR', value: null)
                ],
              ));
        });

    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if when CalculatorOnCalculateEvent is added, is OnloadState emitted with correct multiplication in total',
        setUp: () {
          when(() => mockCurrencyRatesRespository.getCurrencyRate()).thenAnswer(
                  (_) => Future.value(const CurrencyRate(
                  success: true,
                  timestamp: 1234,
                  base: '',
                  date: null,
                  error: null,
                  rates: {"AED": 1.0, "INR": 21.5})));
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn('INR');
        },
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(const CalculatorOnCalculateEvent(
              outputCurrency: 'INR',
              operator: MathematicalExpression.Multiplication,
              firstValue: '5',
              firstCurrency: 'INR',
              secondCurrency: 'INR',
              secondValue: '1',
              conversionRates: [
                CurrencyRateModel(name: 'AED', value: 1.0),
                CurrencyRateModel(name: 'INR', value: 21.5),
              ]));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CalculatorOnLoadState(
                outputCurrency: 'INR',
                operator: MathematicalExpression.Multiplication,
                isReset: false,
                firstValue: '5',
                firstCurrency: 'INR',
                secondCurrency: 'INR',
                secondValue: '1',
                totalValue: 5.0,
                conversionRates: [
                  CurrencyRateModel(name: 'AED', value: null),
                  CurrencyRateModel(name: 'INR', value: null)
                ],
              ));
        });

    blocTest<CalculatorBloc, CalculatorState>(
        'Checking if when CalculatorOnCalculateEvent is added, is OnloadState emitted with correct division in total',
        setUp: () {
          when(() => mockCurrencyRatesRespository.getCurrencyRate()).thenAnswer(
                  (_) => Future.value(const CurrencyRate(
                  success: true,
                  timestamp: 1234,
                  base: '',
                  date: null,
                  error: null,
                  rates: {"AED": 1.0, "INR": 21.5})));
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn('INR');
        },
        build: () => CalculatorBloc(),
        act: (bloc) {
          bloc.add(const CalculatorOnCalculateEvent(
              outputCurrency: 'INR',
              operator: MathematicalExpression.Division,
              firstValue: '1',
              firstCurrency: 'INR',
              secondCurrency: 'INR',
              secondValue: '1',
              conversionRates: [
                CurrencyRateModel(name: 'AED', value: 1.0),
                CurrencyRateModel(name: 'INR', value: 21.5),
              ]));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CalculatorOnLoadState(
                outputCurrency: 'INR',
                operator: MathematicalExpression.Division,
                isReset: false,
                firstValue: '1',
                firstCurrency: 'INR',
                secondCurrency: 'INR',
                secondValue: '1',
                totalValue: 1.0,
                conversionRates: [
                  CurrencyRateModel(name: 'AED', value: null),
                  CurrencyRateModel(name: 'INR', value: null)
                ],
              ));
        });
  });
}
