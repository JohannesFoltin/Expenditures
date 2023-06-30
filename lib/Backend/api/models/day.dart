import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'expenditure.dart';

part 'day.g.dart';

@immutable
@JsonSerializable()
class Day extends Equatable{
  final DateTime day;
  final List<Expenditure> expenditures;

  const Day({
    required this.day,
    this.expenditures = const [],
  });

  factory Day.fromJson(Map<String, dynamic> json) =>
      _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);

  @override
  List<Object> get props => [day];

  Day copyWith({
    DateTime? day,
    List<Expenditure>? expenditures,
  }) {
    return Day(
      day: day ?? this.day,
      expenditures: expenditures ?? this.expenditures,
    );
  }
}