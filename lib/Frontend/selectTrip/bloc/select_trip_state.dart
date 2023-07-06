part of 'select_trip_bloc.dart';

enum State { loading, done }

final class SelectTripState extends Equatable {
  const SelectTripState({this.trips = const [], this.state = State.done});

  final List<Trip> trips;
  final State state;

  @override
  List<Object?> get props => [trips, state];

  SelectTripState copyWith({
    List<Trip>? trips,
    State? state,
  }) {
    return SelectTripState(
      trips: trips ?? this.trips,
      state: state ?? this.state,
    );
  }
}
