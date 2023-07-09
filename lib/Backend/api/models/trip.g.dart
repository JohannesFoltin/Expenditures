// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      startDay: DateTime.parse(json['startDay'] as String),
      endDay: DateTime.parse(json['endDay'] as String),
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      expenditures: (json['expenditures'] as List<dynamic>?)
              ?.map((e) => Expenditure.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyLimit: json['dailyLimit'] as int? ?? 0,
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expenditures': instance.expenditures,
      'dailyLimit': instance.dailyLimit,
      'startDay': instance.startDay.toIso8601String(),
      'endDay': instance.endDay.toIso8601String(),
    };
