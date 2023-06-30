part of 'trip_overview_bloc.dart';

class TripOverviewState extends Equatable {
  const TripOverviewState(
      {required this.currentSelectedDay,
      required this.days,
      required this.trip,
       });

  final Day currentSelectedDay;
  final List<Day> days;
  final Trip trip;

  @override
  List<Object?> get props => [trip,currentSelectedDay, days];

  TripOverviewState copyWith({
    Day? currentSelectedDay,
    List<Day>? days,
    Trip? trip,
  }) {
    return TripOverviewState(
      currentSelectedDay: currentSelectedDay ?? this.currentSelectedDay,
      days: days ?? this.days,
      trip: trip ?? this.trip,
    );
  }
}
