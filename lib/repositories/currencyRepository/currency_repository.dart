import 'dart:async';
import '../../models/currencies_model.dart';
abstract class CurrencyRepository{
  FutureOr<Currencies> getCurrencySymbols();
}