// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenditure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expenditure _$ExpenditureFromJson(Map<String, dynamic> json) => Expenditure(
      id: json['id'] as String?,
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
      category: $enumDecodeNullable(_$CategoriesEnumMap, json['category']) ??
          Categories.sonstige,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      valuePerDay: (json['valuePerDay'] as num?)?.toDouble() ?? 0.0,
      directExpenditure: json['directExpenditure'] as bool? ?? true,
      paidWithCard: json['paidWithCard'] as bool? ?? true,
    );

Map<String, dynamic> _$ExpenditureToJson(Expenditure instance) =>
    <String, dynamic>{
      'category': _$CategoriesEnumMap[instance.category]!,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'valuePerDay': instance.valuePerDay,
      'directExpenditure': instance.directExpenditure,
      'paidWithCard': instance.paidWithCard,
      'days': instance.days.map((e) => e.toIso8601String()).toList(),
    };

const _$CategoriesEnumMap = {
  Categories.essen: 'essen',
  Categories.lebensmittel: 'lebensmittel',
  Categories.schlafen: 'schlafen',
  Categories.transport: 'transport',
  Categories.aktivitaeten: 'aktivitaeten',
  Categories.sonstige: 'sonstige',
};
