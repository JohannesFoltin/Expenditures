import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'trip.g.dart';

@immutable
@JsonSerializable()
class Trip extends Equatable {
  Trip({
    required this.startDay,
    required this.endDay,
    String? id,
    this.name = '',
    this.expenditures = const [],
    this.dailyLimit = 0,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  final String id;
  final String name;
  final List<Expenditure> expenditures;

  //TODO change to Double
  final int dailyLimit;

  //More elegant would be DateTimeRange
  final DateTime startDay;
  final DateTime endDay;

  @override
  List<Object> get props =>
      [id, startDay, endDay, expenditures, dailyLimit, name];
  Map<String, dynamic> toJson() => _$TripToJson(this);

  Trip copyWith({
    String? id,
    String? name,
    List<Expenditure>? expenditures,
    int? dailyLimit,
    DateTime? startDay,
    DateTime? endDay,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      expenditures: expenditures ?? this.expenditures,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
    );
  }
  
  bool isDayInTripTime(DateTime day) {
    final dayTmp = DateUtils.dateOnly(day);
    return (dayTmp.compareTo(startDay) >= 0) &&
        (dayTmp.compareTo(endDay) <= 0);
  }
  List<Expenditure> getExpendituresOnDay(DateTime day) {
    //Ist noetig mit den 2 sekunden weil sonst der letzte Tag nicht erkannt wird
    if (!(day.isAfter(startDay.subtract(const Duration(seconds: 2))) &&
        day.isBefore(endDay.add(const Duration(days: 1))))) {
      return [];
    }
    List<Expenditure> tmp = [];
    for (final exp in expenditures) {
      final hasSameDay =
          exp.days.any((element) => DateUtils.isSameDay(element, day));
      if (hasSameDay) {
        tmp.add(exp);
      }
    }
    return tmp;
  }
}
