part of 'trip_overview_cubit.dart';

enum HomeTab {dayOverview,stats}

class TripOverviewState extends Equatable{

  final Trip trip;
  final HomeTab tab;

  @override
  List<Object> get props => [trip,tab];

  const TripOverviewState({
    required this.trip,
    this.tab = HomeTab.dayOverview,
  });

  TripOverviewState copyWith({
    Trip? trip,
    HomeTab? tab,
  }) {
    return TripOverviewState(
      trip: trip ?? this.trip,
      tab: tab ?? this.tab,
    );
  }
}
