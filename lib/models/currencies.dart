import 'dart:convert';
import 'package:equatable/equatable.dart';

CurrencyModel? currencyModelFromJson(String str) => CurrencyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrencyModel? data) => json.encode(data!.toJson());

class CurrencyModel extends Equatable{
  const CurrencyModel({
    required this.name,
    required this.desc,
  });

  final String? name;
  final String? desc;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
    name: json["key"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "key": name,
    "desc": desc,
  };

  @override
  List<Object?> get props => [name];
}