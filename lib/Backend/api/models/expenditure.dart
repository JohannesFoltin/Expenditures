import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expenditure.g.dart';

enum Categories {
  transport,
  schlafen,
  essen,
  aktivitaeten,
  lebensmittel,
  sonstige
}

@immutable
@JsonSerializable()
class Expenditure extends Equatable {
  Expenditure({
    String? id,
    this.days = const [],
    this.category = Categories.sonstige,
    this.name = '',
    this.description = '',
    this.value = 0.0,
    this.directExpenditure = true,
    this.paidWithCard = true,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  factory Expenditure.fromJson(Map<String, dynamic> json) =>
      _$ExpenditureFromJson(json);

  final Categories category;
  final String id;
  final String name;
  final String description;
  final double value;
  final bool directExpenditure;
  final bool paidWithCard;
  final List<DateTime> days;

  Map<String, dynamic> toJson() => _$ExpenditureToJson(this);


  @override
  List<Object> get props =>
      [id, name, description, value, directExpenditure, paidWithCard,days];

  Expenditure copyWith({
    Categories? category,
    String? id,
    String? name,
    String? description,
    double? value,
    bool? directExpenditure,
    bool? paidWithCard,
    List<DateTime>? days,
  }) {
    return Expenditure(
      category: category ?? this.category,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
      directExpenditure: directExpenditure ?? this.directExpenditure,
      paidWithCard: paidWithCard ?? this.paidWithCard,
      days: days ?? this.days,
    );
  }
}
