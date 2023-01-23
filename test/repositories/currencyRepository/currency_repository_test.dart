
import 'package:calculator/data/api/currencies/get_currencies_api.dart';
import 'package:calculator/models/currencies_model.dart';
import 'package:calculator/repositories/currencyRepository/currency_repository.dart';
import 'package:calculator/repositories/currencyRepository/currency_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockCurrencyRepository extends Mock implements CurrencyRepository {}

class _MockCurrenciesAPI extends Mock
    implements CurrenciesAPI {}

void main() {
  late _MockCurrencyRepository mockCurrencyRepository;
  late _MockCurrenciesAPI mockCurrenciesAPI;

  setUp(() {
    mockCurrencyRepository = _MockCurrencyRepository();
    mockCurrenciesAPI = _MockCurrenciesAPI();
    GetIt.I.registerSingleton<CurrencyRepository>(mockCurrencyRepository);
    GetIt.I
        .registerSingleton<CurrenciesAPI>(mockCurrenciesAPI);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  test(
      'Checking whether app returns currencies or not upon calling repository',
          () async {
        when(() => mockCurrenciesAPI.getCurrencies()).thenAnswer((
            _) =>
        const Currencies(success: true,
            error: null,
            symbols: {
              "AED":"Arab Emirates Dirham","INR":"Indian Rupee"
            }));

        final result = await CurrencyRepositoryImpl().getCurrencySymbols();

        expect(result, const Currencies(success: true,
            error: null,
            symbols: {
              "AED":"Arab Emirates Dirham","INR":"Indian Rupee"
            }));
      });
}
