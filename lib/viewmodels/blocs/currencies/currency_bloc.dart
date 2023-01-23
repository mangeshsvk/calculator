import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '/core/constants/storage_keys.dart';
import '/repositories/currencyRepository/currency_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/currencies.dart';

part 'currency_event.dart';

part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final sharedPref = GetIt.I<SharedPreferences>();
  final currencyRepo = GetIt.I<CurrencyRepository>();

  CurrencyBloc() : super(CurrencyInitial()) {
    on<CurrencyOnLoadEvent>(_onLoadState);
    on<CurrencyOnUpdateEvent>(_onUpdateState);
    on<CurrencyOnSavedEvent>(_onSavedState);
  }

  FutureOr<void> _onLoadState(
      CurrencyOnLoadEvent event, Emitter<CurrencyState> emit) async {
    emit(CurrencyLoadingState());
    final data = await currencyRepo.getCurrencySymbols();
    final outputCurrency = sharedPref.getString(StorageKeys.outputCurrency);
    if (data.error == null || data.success == false) {
      List<CurrencyModel>? currencies = data.symbols == null
          ? []
          : data.symbols?.entries
              .map((entry) => CurrencyModel(name: entry.key, desc: entry.value))
              .toList();
      emit(CurrencyOnLoadState(
          currencies: currencies ?? [],
          selectedCurrency: CurrencyModel(name: outputCurrency, desc: '')));
    } else {
      emit(CurrencyErrorState(error: data.error ?? ''));
    }
  }

  FutureOr<void> _onUpdateState(
      CurrencyOnUpdateEvent event, Emitter<CurrencyState> emit) async {
    emit(CurrencyOnLoadState(
        currencies: event.currencies,
        selectedCurrency: CurrencyModel(name: event.selectedCurrency, desc: '')));
  }

  FutureOr<void> _onSavedState(
      CurrencyOnSavedEvent event, Emitter<CurrencyState> emit) async {
    try{
      await sharedPref.setString(StorageKeys.outputCurrency, event.selectedCurrency);
      emit(const CurrencyOnSavedState(
          successMessage: 'Output Currency Saved Successfully !!!'));
    }
    catch(e){
      emit( CurrencyErrorState(
          error: e.toString()));
    }
  }
}
