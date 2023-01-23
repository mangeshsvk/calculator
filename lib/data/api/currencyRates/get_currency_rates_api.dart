import 'dart:async';
import '/models/currency_rates.dart';

abstract class CurrencyRatesAPI{
  FutureOr<CurrencyRate> getCurrencyRates();
}