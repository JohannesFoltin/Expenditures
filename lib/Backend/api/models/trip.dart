import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'day.dart';

part 'trip.g.dart';

@immutable
@JsonSerializable()
class Trip extends Equatable{
  final String id;
  final List<Day> days;
  final int dailyLimit;

  Trip({
    String? id,
    this.days = const [],
    this.dailyLimit = 0,
    }): assert( id == null || id.isNotEmpty,
  'id can not be null and should be empty',
  ),id = id ?? const Uuid().v4();

  @override
  List<Object> get props => [days,dailyLimit];
  factory Trip.fromJson(Map<String, dynamic> json) =>
      _$TripFromJson(json);
  Map<String, dynamic> toJson() => _$TripToJson(this);
  Trip copyWith({
    List<Day>? days,
    int? dailyLimit,
  }) {
    return Trip(
      days: days ?? this.days,
      dailyLimit: dailyLimit ?? this.dailyLimit,
    );
  }
}