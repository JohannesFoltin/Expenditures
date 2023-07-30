part of 'settings_bloc.dart';

enum State { loading, done }

final class SettingsState extends Equatable {

  const SettingsState({
    this.state = State.loading,  this.selectedTrip, this.trips = const [],
  });

  final Trip? selectedTrip;
  final State state;
  final List<Trip> trips;

  @override
  List<Object?> get props => [selectedTrip,state,trips];

  SettingsState copyWith({
    Trip? selectedTrip,
    State? state,
    List<Trip>? trips,
  }) {
    return SettingsState(
      selectedTrip: selectedTrip ?? this.selectedTrip,
      state: state ?? this.state,
      trips: trips ?? this.trips,
    );
  }
}


