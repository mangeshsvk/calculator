part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object?> get props => [];
}

class CurrencyOnLoadEvent extends CurrencyEvent {
  final String currentCurrencySymbol;

  const CurrencyOnLoadEvent({required this.currentCurrencySymbol});
}

class CurrencyOnUpdateEvent extends CurrencyEvent {
  final List<CurrencyModel> currencies;
  final String? selectedCurrency;

  const CurrencyOnUpdateEvent(
      {required this.selectedCurrency, required this.currencies});

  @override
  List<Object?> get props => [currencies, selectedCurrency];
}

class CurrencyOnSavedEvent extends CurrencyEvent {
  final String selectedCurrency;
  const CurrencyOnSavedEvent({required this.selectedCurrency});

  @override
  List<Object?> get props => [selectedCurrency];
}
