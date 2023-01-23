import 'package:calculator/core/constants/storage_keys.dart';
import 'package:calculator/models/currencies.dart';
import 'package:calculator/models/currencies_model.dart';
import 'package:calculator/repositories/currencyRepository/currency_repository.dart';
import 'package:calculator/viewmodels/blocs/currencies/currency_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_test/bloc_test.dart';

class _MockCurrencyRepo extends Mock implements CurrencyRepository {}

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late _MockCurrencyRepo mockCurrencyRepo;
  late _MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockCurrencyRepo = _MockCurrencyRepo();
    mockSharedPreferences = _MockSharedPreferences();
    GetIt.I.registerSingleton<CurrencyRepository>(mockCurrencyRepo);
    GetIt.I.registerSingleton<SharedPreferences>(mockSharedPreferences);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('Checking Currency Bloc On Load State', () {
    blocTest<CurrencyBloc, CurrencyState>(
        'Checking if OnLoadState emitted on AppOnLoadState',
        setUp: () {
          when(() => mockCurrencyRepo.getCurrencySymbols())
              .thenAnswer((_) => Future.value(const Currencies(
                    success: true,
                    error: null,
                    symbols: {"INR": "Indian Rupee", "USD": "American Dollar"},
                  )));
          when(() => mockSharedPreferences.getString(any())).thenReturn('INR');
        },
        build: () => CurrencyBloc(),
        act: (bloc) {
          bloc.add(const CurrencyOnLoadEvent(currentCurrencySymbol: 'INR'));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CurrencyOnLoadState(
                  selectedCurrency: CurrencyModel(name: 'INR', desc: ''),
                  currencies: [
                    CurrencyModel(name: 'INR', desc: ''),
                    CurrencyModel(name: 'USD', desc: '')
                  ]));
        });

    blocTest<CurrencyBloc, CurrencyState>(
        'Checking if Error State is emitted on Receiving error from data',
        setUp: () {
          when(() => mockCurrencyRepo.getCurrencySymbols())
              .thenAnswer((_) => Future.value(const Currencies(
                    success: true,
                    error: 'Something went wrong',
                    symbols: {"INR": "Indian Rupee", "USD": "American Dollar"},
                  )));
          when(() => mockSharedPreferences.getString(any())).thenReturn('INR');
        },
        build: () => CurrencyBloc(),
        act: (bloc) {
          bloc.add(const CurrencyOnLoadEvent(currentCurrencySymbol: 'INR'));
        },
        verify: (bloc) {
          expect(bloc.state,
              const CurrencyErrorState(error: 'Something went wrong'));
        });
  });

  group('Checking Currency Bloc On Update State', () {
    blocTest<CurrencyBloc, CurrencyState>(
        'Checking if OnLoadState emitted on Update State with updated data',
        build: () => CurrencyBloc(),
        act: (bloc) {
          bloc.add(const CurrencyOnUpdateEvent(
              selectedCurrency: 'USD',
              currencies: [
                CurrencyModel(name: 'INR', desc: ''),
                CurrencyModel(name: 'USD', desc: '')
              ]));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CurrencyOnLoadState(
                  selectedCurrency: CurrencyModel(name: 'USD', desc: ''),
                  currencies: [
                    CurrencyModel(name: 'INR', desc: ''),
                    CurrencyModel(name: 'USD', desc: '')
                  ]));
        });
  });
  group('Checking Currency Bloc On Saved Event', () {
    blocTest<CurrencyBloc, CurrencyState>(
        'Checking if Success State is emitted on saving selected currency',
        setUp: () {
          when(() => mockSharedPreferences.setString(StorageKeys.outputCurrency,any())).thenAnswer((invocation) => Future.value(true));
        },
        build: () => CurrencyBloc(),
        act: (bloc) {
          bloc.add(const CurrencyOnSavedEvent(
              selectedCurrency: 'USD',));
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const CurrencyOnSavedState(
                  successMessage: 'Output Currency Saved Successfully !!!'));
        });
  });
}
