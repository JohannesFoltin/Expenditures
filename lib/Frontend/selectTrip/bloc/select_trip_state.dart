part of 'select_trip_bloc.dart';

enum STState { loading, done }

final class SelectTripState extends Equatable {
  const SelectTripState(
      {required this.fastForward,
      this.trips = const [],
      this.state = STState.done});

  final List<Trip> trips;
  final bool fastForward;
  final STState state;

  @override
  List<Object?> get props => [trips, state,fastForward];

  SelectTripState copyWith({
    List<Trip>? trips,
    bool? fastForward,
    STState? state,
  }) {
    return SelectTripState(
      trips: trips ?? this.trips,
      fastForward: fastForward ?? this.fastForward,
      state: state ?? this.state,
    );
  }
}
