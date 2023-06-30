part of 'select_trip_bloc.dart';

class SelectTripState extends Equatable {
  const SelectTripState({this.trips = const []});

  final List<Trip> trips;


  @override
  List<Object?> get props => [trips];

  SelectTripState copyWith({
    List<Trip>? trips,
  }) {
    return SelectTripState(
      trips: trips ?? this.trips,
    );
  }
}

