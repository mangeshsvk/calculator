import 'dart:async';

import '../../../models/currencies_model.dart';


abstract class CurrenciesAPI{
  FutureOr<Currencies> getCurrencies();
}
