import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expenditure.g.dart';

@immutable
@JsonSerializable()
class Expenditure extends Equatable{
  final String id;
  final String name;
  final String description;
  final int value;
  final bool directExpenditure;
  final bool paidWithCard;

  Expenditure({
    String? id,
    this.name = "",
    this.description = "",
    this.value = 0,
    this.directExpenditure= true,
    this.paidWithCard = true,
    }) : assert( id == null || id.isNotEmpty,
  'id can not be null and should be empty',
  ),id = id ?? const Uuid().v4();

  factory Expenditure.fromJson(Map<String, dynamic> json) =>
      _$ExpenditureFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenditureToJson(this);
  Expenditure copyWith({
    String? id,
    String? name,
    String? description,
    int? value,
    bool? directExpenditure,
    bool? paidWithCard,
  }) {
    return Expenditure(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
      directExpenditure: directExpenditure ?? this.directExpenditure,
      paidWithCard: paidWithCard ?? this.paidWithCard,
    );
  }

  @override
  List<Object> get props => [id];
}