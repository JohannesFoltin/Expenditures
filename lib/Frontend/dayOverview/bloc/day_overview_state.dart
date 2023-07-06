part of 'day_overview_bloc.dart';

enum DayState {loading, done, failure}

final class DayOverviewState extends Equatable {
  const DayOverviewState(
      {required this.currentSelectedDay,
      required this.trip,
        this.dayState = DayState.loading,
        this.selectCategory = false,
       });

  final DayState dayState;
  final Day currentSelectedDay;
  final Trip trip;
  final bool selectCategory;

  @override
  List<Object?> get props => [trip,currentSelectedDay,dayState,selectCategory];

  DayOverviewState copyWith({
    DayState? dayState,
    Day? currentSelectedDay,
    Trip? trip,
    bool? selectCategory,
  }) {
    return DayOverviewState(
      dayState: dayState ?? this.dayState,
      currentSelectedDay: currentSelectedDay ?? this.currentSelectedDay,
      trip: trip ?? this.trip,
      selectCategory: selectCategory ?? this.selectCategory,
    );
  }
}
