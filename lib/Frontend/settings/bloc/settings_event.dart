part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {}

class Subscribe extends SettingsEvent{
  @override
  List<Object?> get props => [];
}

class SelectTrip extends SettingsEvent{

  SelectTrip({
    required this.trip,
  });

  final Trip? trip;

  @override
  List<Object?> get props => [trip];
}