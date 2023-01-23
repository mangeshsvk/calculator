import 'package:calculator/core/constants/storage_keys.dart';
import 'package:calculator/viewmodels/blocs/app/app_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_test/bloc_test.dart';

const ConnectivityResult kCheckConnectivityResult = ConnectivityResult.wifi;

class _MockConnectivity extends Mock implements Connectivity {
  @override
  Future<ConnectivityResult> checkConnectivity() {
    return Future.value(kCheckConnectivityResult);
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => Stream<ConnectivityResult>.fromIterable([kCheckConnectivityResult]);
}

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late _MockConnectivity mockConnectivity;
  late _MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockConnectivity = _MockConnectivity();
    mockSharedPreferences = _MockSharedPreferences();
    GetIt.I.registerSingleton<Connectivity>(mockConnectivity);
    GetIt.I.registerSingleton<SharedPreferences>(mockSharedPreferences);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('Checking whenever internet goes offline is application moving to offline mode or not', () {
    blocTest<AppBloc, AppState>(
        'Application should emit onload state with isOnline as false when app is on offline mode',
        setUp: () {
          when(() => mockSharedPreferences.getString(any())).thenReturn('AED');
          when(() => mockSharedPreferences.setBool(StorageKeys.isOnline,false)).thenAnswer((_)=>Future.value(false));
        },
        build: () => AppBloc(),
        act: (bloc) {
          bloc.add(AppOfflineEvent());
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const AppOnLoadState(
                  isOnline: false, isOutputCurrencyAvailable: true));
        });
  });
  group('Checking whenever internet goes online is application moving to online mode or not', () {
    blocTest<AppBloc, AppState>(
        'Application should emit onload state with isOnline as true when app is on online mode',
        setUp: () {
          when(() => mockSharedPreferences.getString(any())).thenReturn('AED');
          when(() => mockSharedPreferences.setBool(StorageKeys.isOnline,true)).thenAnswer((_)=>Future.value(true));
        },
        build: () => AppBloc(),
        act: (bloc) {
          bloc.add(AppOnlineEvent());
        },
        verify: (bloc) {
          expect(
              bloc.state,
              const AppOnLoadState(
                  isOnline: true, isOutputCurrencyAvailable: true));
        });
  });
}
