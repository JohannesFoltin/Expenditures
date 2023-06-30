// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      id: json['id'] as String?,
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyLimit: json['dailyLimit'] as int? ?? 0,
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id': instance.id,
      'days': instance.days,
      'dailyLimit': instance.dailyLimit,
    };
