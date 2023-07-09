part of 'day_overview_bloc.dart';

enum DayState { loading, done, failure }

final class DayOverviewState extends Equatable {
  const DayOverviewState({
    required this.currentSelectedDay,
    required this.expendituresOnCurrentDay,
    required this.trip,
    this.dayState = DayState.loading,
    this.selectCategory = false,
  });

  final DayState dayState;
  final DateTime currentSelectedDay;
  final Trip trip;
  final bool selectCategory;
  final List<Expenditure> expendituresOnCurrentDay;

  @override
  List<Object?> get props => [
        trip,
        currentSelectedDay,
        dayState,
        selectCategory,
        expendituresOnCurrentDay
      ];

  DayOverviewState copyWith({
    DayState? dayState,
    DateTime? currentSelectedDay,
    Trip? trip,
    bool? selectCategory,
    List<Expenditure>? expendituresOnCurrentDay,
  }) {
    return DayOverviewState(
      dayState: dayState ?? this.dayState,
      currentSelectedDay: currentSelectedDay ?? this.currentSelectedDay,
      trip: trip ?? this.trip,
      selectCategory: selectCategory ?? this.selectCategory,
      expendituresOnCurrentDay:
          expendituresOnCurrentDay ?? this.expendituresOnCurrentDay,
    );
  }
}
