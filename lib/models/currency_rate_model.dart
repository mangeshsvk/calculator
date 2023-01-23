import 'dart:convert';
import 'package:equatable/equatable.dart';

CurrencyRateModel? currencyRateModelFromJson(String str) => CurrencyRateModel.fromJson(json.decode(str));

String currencyRateModelToJson(CurrencyRateModel? data) => json.encode(data!.toJson());

class CurrencyRateModel extends Equatable{
  const CurrencyRateModel({
    required this.name,
    required this.value,
  });

  final String? name;
  final double? value;

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) => CurrencyRateModel(
    name: json["key"],
    value: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "key": name,
    "rate": value,
  };

  @override
  List<Object?> get props => [name];
}