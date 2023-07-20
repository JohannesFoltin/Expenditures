part of 'stats_bloc.dart';

enum StatsStates { loading, done }

class StatsState extends Equatable {
  const StatsState({
    required this.trip,
    this.state = StatsStates.done,
    this.allExpenditures = 0,
    this.expendituresPerDay = 0,
    this.onlyCountableExpenditures = 0,
    this.allCategoriesAndExpenditures = const {},
    this.countableCategoriesAndExpenditures = const {},
  });

  final StatsStates state;
  final Trip trip;
  final double expendituresPerDay;
  final double allExpenditures;
  final double onlyCountableExpenditures;
  final Map<Categories, double> allCategoriesAndExpenditures;
  final Map<Categories, double> countableCategoriesAndExpenditures;

  @override
  List<Object?> get props => [
        trip,
        expendituresPerDay,
        allExpenditures,
        onlyCountableExpenditures,
      ];


  StatsState copyWith({
    StatsStates? state,
    Trip? trip,
    double? expendituresPerDay,
    double? allExpenditures,
    double? onlyCountableExpenditures,
    Map<Categories, double>? allCategoriesAndExpenditures,
    Map<Categories, double>? countableCategoriesAndExpenditures,
  }) {
    return StatsState(
      state: state ?? this.state,
      trip: trip ?? this.trip,
      expendituresPerDay: expendituresPerDay ?? this.expendituresPerDay,
      allExpenditures: allExpenditures ?? this.allExpenditures,
      onlyCountableExpenditures:
          onlyCountableExpenditures ?? this.onlyCountableExpenditures,
      allCategoriesAndExpenditures:
          allCategoriesAndExpenditures ?? this.allCategoriesAndExpenditures,
      countableCategoriesAndExpenditures: countableCategoriesAndExpenditures ??
          this.countableCategoriesAndExpenditures,
    );
  }
}
