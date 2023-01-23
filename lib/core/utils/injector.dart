import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '/repositories/currencyRatesRepository/currency_rates_repository.dart';
import '/repositories/currencyRatesRepository/currency_rates_repository_impl.dart';
import '/data/api/currencyRates/get_currency_rates_api.dart';
import '/data/api/currencyRates/get_currency_rates_api_impl.dart';
import '/data/api/currencies/get_currencies_api_impl.dart';
import '/repositories/currencyRepository/currency_repository.dart';
import '/repositories/currencyRepository/currency_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/currencies/get_currencies_api.dart';

typedef AppRunner = FutureOr<void> Function();

class Injector {
  static Future<void> init({
    required AppRunner appRunner,
  }) async {
    await _initDependencies();
    appRunner();
  }

  static Future<void> _initDependencies() async {
    await _injectUtils();
    _injectRepositories();
    _injectApi();
    await GetIt.I.allReady();
  }
}

FutureOr<void> _injectUtils() async {
  GetIt.I.registerLazySingleton<Dio>(() => Dio());
  GetIt.I.registerSingletonAsync<SharedPreferences>(
          () => SharedPreferences.getInstance());
  GetIt.I.registerLazySingleton<Connectivity>(() => Connectivity());
}

void _injectRepositories() {
  GetIt.I.registerLazySingleton<CurrencyRatesRespository>(() => CurrencyRatesRepositoryImpl());
  GetIt.I.registerLazySingleton<CurrencyRepository>(() => CurrencyRepositoryImpl());
}



void _injectApi() {
  GetIt.I.registerLazySingleton<CurrencyRatesAPI>(() => CurrencyRatesApiImpl());
  GetIt.I.registerLazySingleton<CurrenciesAPI>(() => CurrenciesAPIImpl());
}

