import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '/core/constants/app_constants.dart';
import '/models/currencies_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/storage_keys.dart';
import 'get_currencies_api.dart';

class CurrenciesAPIImpl extends CurrenciesAPI {
  final apiClient = GetIt.I<Dio>();
  final sharedPref = GetIt.I<SharedPreferences>();

  @override
  FutureOr<Currencies> getCurrencies() async {
    final localCache = sharedPref.getString(StorageKeys.availableCurrencies);
    final isOnline = sharedPref.getBool(StorageKeys.isOnline);
    try {
      if(isOnline??false) {
        final response = await apiClient.get(
            'https://api.apilayer.com/exchangerates_data/symbols',
            options: Options()
              ..headers = <String, dynamic>{'apikey': AppConsts.apiKey});
        sharedPref.setString(StorageKeys.availableCurrencies, jsonEncode(response.data));
        return Currencies.fromJson(response.data);
      }else if (localCache!=null){
        return Currencies.fromJson(jsonDecode(localCache));
      }
      else{
        return Currencies.fromJson(const {'error': 'Something wrong'});
      }
    } on SocketException catch (e) {
      return Currencies.fromJson({'error': e.message});
    }  catch (e) {
      if (e is DioError) {
        return Currencies.fromJson({'error': e.error});
      } else {
        return Currencies.fromJson(const {'error': 'Something wrong'});
      }
    }
  }
}
