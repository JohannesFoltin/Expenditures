part of 'day_overview_bloc.dart';

enum DayState {loading, done, failure}

final class DayOverviewState extends Equatable {
  const DayOverviewState(
      {required this.currentSelectedDay,
      required this.trip,
        this.dayState = DayState.loading,
       });

  final DayState dayState;
  final Day currentSelectedDay;
  final Trip trip;

  @override
  List<Object?> get props => [trip,currentSelectedDay,dayState];

  DayOverviewState copyWith({
    DayState? dayState,
    Day? currentSelectedDay,
    Trip? trip,
  }) {
    return DayOverviewState(
      dayState: dayState ?? this.dayState,
      currentSelectedDay: currentSelectedDay ?? this.currentSelectedDay,
      trip: trip ?? this.trip,
    );
  }
}
