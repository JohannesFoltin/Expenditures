import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'settings.g.dart';


@immutable
@JsonSerializable()
class Settings extends Equatable {

  const Settings({
    this.tripIDofSelectedTrip,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  final String? tripIDofSelectedTrip;

  @override
  List<Object?> get props => [tripIDofSelectedTrip];

  Settings copyWith({
    String? tripIDofSelectedTrip,
  }) {
    return Settings(
      tripIDofSelectedTrip: tripIDofSelectedTrip ?? this.tripIDofSelectedTrip,
    );
  }
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}