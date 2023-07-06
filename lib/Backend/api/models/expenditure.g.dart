// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenditure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expenditure _$ExpenditureFromJson(Map<String, dynamic> json) => Expenditure(
      id: json['id'] as String?,
      category: $enumDecodeNullable(_$CategoriesEnumMap, json['category']) ??
          Categories.sonstige,
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      value: json['value'] as int? ?? 0,
      directExpenditure: json['directExpenditure'] as bool? ?? true,
      paidWithCard: json['paidWithCard'] as bool? ?? true,
    );

Map<String, dynamic> _$ExpenditureToJson(Expenditure instance) =>
    <String, dynamic>{
      'category': _$CategoriesEnumMap[instance.category]!,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'value': instance.value,
      'directExpenditure': instance.directExpenditure,
      'paidWithCard': instance.paidWithCard,
    };

const _$CategoriesEnumMap = {
  Categories.transport: 'transport',
  Categories.schlafen: 'schlafen',
  Categories.essen: 'essen',
  Categories.aktivitaeten: 'aktivitaeten',
  Categories.lebensmittel: 'lebensmittel',
  Categories.sonstige: 'sonstige',
};
