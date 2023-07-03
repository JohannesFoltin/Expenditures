part of 'day_overview_bloc.dart';

class DayOverviewState extends Equatable {
  const DayOverviewState(
      {required this.currentSelectedDay,
      required this.days,
      required this.trip,
       });

  final Day currentSelectedDay;
  final List<Day> days;
  final Trip trip;

  @override
  List<Object?> get props => [trip,currentSelectedDay, days];

  DayOverviewState copyWith({
    Day? currentSelectedDay,
    List<Day> Function()? days,
    Trip? trip,
  }) {
    return DayOverviewState(
      currentSelectedDay: currentSelectedDay ?? this.currentSelectedDay,
      days: days != null ? days() : this.days,
      trip: trip ?? this.trip,
    );
  }
}
