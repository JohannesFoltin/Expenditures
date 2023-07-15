part of 'stats_bloc.dart';

enum StatsStates { loading, done }

class StatsState extends Equatable {
  const StatsState({
    required this.trip,
    this.state = StatsStates.done,
  });

  final StatsStates state;
  final Trip trip;
  @override
  List<Object?> get props => [trip];

  double getAllExpendituresValeues() {
    var tmp = 0.0;
    for (final value in trip.expenditures) {
      tmp = tmp + (value.valuePerDay * value.days.length);
    }
    return tmp;
  }

  StatsState copyWith({
    StatsStates? state,
    Trip? trip,
  }) {
    return StatsState(
      state: state ?? this.state,
      trip: trip ?? this.trip,
    );
  }
}
