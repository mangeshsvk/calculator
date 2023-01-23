import 'dart:convert';

import 'package:equatable/equatable.dart';

CurrencyRate? currencyRateFromJson(String str) => CurrencyRate.fromJson(json.decode(str));

String currencyRateToJson(CurrencyRate? data) => json.encode(data!.toJson());

class CurrencyRate extends Equatable {
  const CurrencyRate({
    required this.success,
    required this.timestamp,
    required this.base,
    required this.date,
    required this.error,
    required this.rates,
  });

  final bool? success;
  final int? timestamp;
  final String? base;
  final DateTime? date;
  final String? error;
  final Map<String, double?>? rates;

  factory CurrencyRate.fromJson(Map<String, dynamic> json) => CurrencyRate(
    success: json["success"],
    timestamp: json["timestamp"],
    base: json["base"],
    error: json["error"],
    date: json["date"]==null?DateTime.now():DateTime.parse(json["date"]),
    rates: json["rates"]==null?null:Map.from(json["rates"]!).map((k, v) => MapEntry<String, double?>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "timestamp": timestamp,
    "base": base,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "rates": Map.from(rates!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };

  @override
  List<Object?> get props => [success,timestamp,base,date,rates];
}
