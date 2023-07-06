part of 'trip_overview_bloc.dart';

enum TripState { loading, done , failure}

final class TripOverviewState extends Equatable {
  const TripOverviewState(
      {required this.trip, this.tripState = TripState.loading,});

  final TripState tripState;
  final Trip trip;

  @override
  List<Object?> get props => [trip,tripState];

  TripOverviewState copyWith({
    TripState? tripState,
    Trip? trip,
  }) {
    return TripOverviewState(
      tripState: tripState ?? this.tripState,
      trip: trip ?? this.trip,
    );
  }
}
