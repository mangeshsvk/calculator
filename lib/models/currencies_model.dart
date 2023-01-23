import 'dart:convert';

import 'package:equatable/equatable.dart';

Currencies? currenciesFromJson(String str) =>
    Currencies.fromJson(json.decode(str));

String currenciesToJson(Currencies? data) =>
    json.encode(data!.toJson());

class Currencies extends Equatable {
 const Currencies({
    required this.success,
    required this.error,
    this.symbols,
  });

  final bool? success;
  final String? error;
  final Map<String, String?>? symbols;

  factory Currencies.fromJson(Map<String, dynamic> json) =>
      Currencies(
        success: json["success"],
        symbols: json["symbols"] == null
            ? null
            : Map.from(json["symbols"]!)
                .map((k, v) => MapEntry<String, String?>(k, v)),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "symbols":
            Map.from(symbols!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };

  @override
  List<Object?> get props => [success,symbols,error];
}

