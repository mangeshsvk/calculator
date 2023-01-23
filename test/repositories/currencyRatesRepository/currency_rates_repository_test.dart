import 'package:calculator/data/api/currencyRates/get_currency_rates_api.dart';
import 'package:calculator/models/currency_rates.dart';
import 'package:calculator/repositories/currencyRatesRepository/currency_rates_repository.dart';
import 'package:calculator/repositories/currencyRatesRepository/currency_rates_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockCurrencyRatesRepository extends Mock
    implements CurrencyRatesRespository {}

class _MockCurrencyRatesAPI extends Mock implements CurrencyRatesAPI {}

void main() {
  late _MockCurrencyRatesRepository mockCurrencyRatesRepository;
  late _MockCurrencyRatesAPI mockCurrencyRatesAPI;

  setUp(() {
    mockCurrencyRatesRepository = _MockCurrencyRatesRepository();
    mockCurrencyRatesAPI = _MockCurrencyRatesAPI();
    GetIt.I.registerSingleton<CurrencyRatesRespository>(
        mockCurrencyRatesRepository);
    GetIt.I.registerSingleton<CurrencyRatesAPI>(mockCurrencyRatesAPI);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  test('Checking whether getting currency rates or not upon calling repository',
      () async {
    when(() => mockCurrencyRatesAPI.getCurrencyRates()).thenAnswer((_) =>
        const CurrencyRate(
            success: true,
            timestamp: 1234,
            base: 'AED',
            date: null,
            error: null,
            rates: {"AED": 1, "INR": 21.5}));

    final result = await CurrencyRatesRepositoryImpl().getCurrencyRate();

    expect(
        result,
        const CurrencyRate(
            success: true,
            timestamp: 1234,
            base: 'AED',
            date: null,
            error: null,
            rates: {"AED": 1, "INR": 21.5}));
  });
}
