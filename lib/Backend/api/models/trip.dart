import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'day.dart';

part 'trip.g.dart';

@immutable
@JsonSerializable()
class Trip extends Equatable {
  Trip({
    String? id,
    this.name = '',
    this.days = const [],
    this.dailyLimit = 0,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  final String id;
  final String name;
  final List<Day> days;
  final int dailyLimit;

  @override
  List<Object> get props => [id, days, dailyLimit,name];
  Map<String, dynamic> toJson() => _$TripToJson(this);

  Trip copyWith({
    String? id,
    String? name,
    List<Day>? days,
    int? dailyLimit,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
      dailyLimit: dailyLimit ?? this.dailyLimit,
    );
  }
}
