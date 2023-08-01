part of 'select_trip_bloc.dart';

enum STState { loading, done }

final class SelectTripState extends Equatable {
  const SelectTripState({this.trips = const [], this.state = STState.done});

  final List<Trip> trips;
  final STState state;

  @override
  List<Object?> get props => [trips, state];

  SelectTripState copyWith({
    List<Trip>? trips,
    STState? state,
  }) {
    return SelectTripState(
      trips: trips ?? this.trips,
      state: state ?? this.state,
    );
  }
}
