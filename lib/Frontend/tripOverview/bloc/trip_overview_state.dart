part of 'trip_overview_bloc.dart';

class TripOverviewState extends Equatable {
  const TripOverviewState({required this.trip});
  final Trip trip;


  @override
  List<Object?> get props => [trip];

  TripOverviewState copyWith({
    Trip Function()? trip,
  }) {
    return TripOverviewState(
      trip: trip != null ? trip() : this.trip,
    );
  }
}

