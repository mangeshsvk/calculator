import 'dart:async';
import '../../models/currency_rates.dart';

abstract class CurrencyRatesRespository{
  FutureOr<CurrencyRate> getCurrencyRate();
}