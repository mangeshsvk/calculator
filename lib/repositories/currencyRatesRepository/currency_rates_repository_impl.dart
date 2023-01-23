import 'dart:async';
import '/data/api/currencyRates/get_currency_rates_api.dart';
import '/models/currency_rates.dart';
import 'package:get_it/get_it.dart';
import '/repositories/currencyRatesRepository/currency_rates_repository.dart';

class CurrencyRatesRepositoryImpl extends CurrencyRatesRespository{
  final currencyRateAPI = GetIt.I<CurrencyRatesAPI>();

  @override
  FutureOr<CurrencyRate> getCurrencyRate() {
    return currencyRateAPI.getCurrencyRates();
  }
}