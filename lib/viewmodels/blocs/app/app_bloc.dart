import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final sharedPref = GetIt.I<SharedPreferences>();
  final connectivity = GetIt.I<Connectivity>();

  AppBloc() : super(AppInitial()) {
    on<AppOnLoadEvent>(_checkAppState);
    on<AppOfflineEvent>(_appOfflineState);
    on<AppOnlineEvent>(_appOnlineState);
  }

  FutureOr<void> _checkAppState(
      AppOnLoadEvent event, Emitter<AppState> emit) async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      add(AppOfflineEvent());
    } else {
      add(AppOnlineEvent());
    }
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        add(AppOfflineEvent());
      } else {
        add(AppOnlineEvent());
      }
    });
  }

  FutureOr<void> _appOfflineState(
      AppOfflineEvent event, Emitter<AppState> emit) async {
    emit(const AppLoadingState());
    sharedPref.setBool(StorageKeys.isOnline, false);
    final outputCurrency = sharedPref.getString(StorageKeys.outputCurrency);
    emit(AppOnLoadState(
        isOnline: false,
        isOutputCurrencyAvailable: outputCurrency == null ? false : true));
  }

  FutureOr<void> _appOnlineState(
      AppOnlineEvent event, Emitter<AppState> emit) async {
     sharedPref.setBool(StorageKeys.isOnline, true);
    final outputCurrency = sharedPref.getString(StorageKeys.outputCurrency);
    emit(AppOnLoadState(
        isOnline: true,
        isOutputCurrencyAvailable: outputCurrency == null ? false : true));
  }
}
