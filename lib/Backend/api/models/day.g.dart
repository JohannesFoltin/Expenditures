// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      day: DateTime.parse(json['day'] as String),
      expenditures: (json['expenditures'] as List<dynamic>?)
              ?.map((e) => Expenditure.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'day': instance.day.toIso8601String(),
      'expenditures': instance.expenditures,
    };
