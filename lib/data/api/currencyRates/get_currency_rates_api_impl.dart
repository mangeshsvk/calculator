import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '/data/api/currencyRates/get_currency_rates_api.dart';
import '/core/constants/app_constants.dart';
import '/models/currency_rates.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/storage_keys.dart';

class CurrencyRatesApiImpl extends CurrencyRatesAPI {
  final apiClient = GetIt.I<Dio>();
  final sharedPref = GetIt.I<SharedPreferences>();

  @override
  FutureOr<CurrencyRate> getCurrencyRates() async {

    try {
      final localCache = sharedPref.getString(StorageKeys.conversionRates);
      final isOnline = sharedPref.getBool(StorageKeys.isOnline);
      if(isOnline??false){
        final response = await apiClient.get(
            'https://api.apilayer.com/exchangerates_data/latest',
            options: Options()
              ..headers = <String, dynamic>{'apikey': AppConsts.apiKey});
        sharedPref.setString(StorageKeys.conversionRates, jsonEncode(response.data));
        print(sharedPref.get(StorageKeys.conversionRates));
        return CurrencyRate.fromJson(response.data);
      }
      else if(localCache!=null){
        return CurrencyRate.fromJson(jsonDecode(localCache));
      }
      else{
        return CurrencyRate.fromJson(const {'error': 'Something wrong'});
      }
    }
    on SocketException catch (e) {
      return CurrencyRate.fromJson({'error': e.message.toString()});
    } catch (e) {
      if (e is DioError) {
        return CurrencyRate.fromJson({'error': e.error});
      } else {
        return CurrencyRate.fromJson(const {'error': 'Something wrong'});
      }
    }
  }
}
