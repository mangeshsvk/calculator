part of 'currency_bloc.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();
  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {

}

class CurrencyOnLoadState extends CurrencyState{
  final List<CurrencyModel> currencies;
  final CurrencyModel? selectedCurrency;
  const CurrencyOnLoadState({required this.currencies,this.selectedCurrency});
  @override
  List<Object?> get props => [currencies,selectedCurrency];
}
class CurrencyErrorState extends CurrencyState{
  final String error;
  const CurrencyErrorState({required this.error});
  @override
  List<Object> get props => [error];
}
class CurrencyLoadingState extends CurrencyState{}

class CurrencyOnSavedState extends CurrencyState{
  final String successMessage;
  const CurrencyOnSavedState({required this.successMessage});
}