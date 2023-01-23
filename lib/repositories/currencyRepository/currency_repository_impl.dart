import 'dart:async';
import '/models/currencies_model.dart';
import '/repositories/currencyRepository/currency_repository.dart';
import 'package:get_it/get_it.dart';

import '../../data/api/currencies/get_currencies_api.dart';
class CurrencyRepositoryImpl extends CurrencyRepository{
  final currencyAPI = GetIt.I<CurrenciesAPI>();
  @override
  FutureOr<Currencies> getCurrencySymbols() {
   return  currencyAPI.getCurrencies();
  }
}