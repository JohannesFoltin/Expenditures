part of 'trip_overview_bloc.dart';

abstract class TripOverviewEvent extends Equatable {
  const TripOverviewEvent();

}
class TripOverviewSubscriptionRequest extends TripOverviewEvent{
  const TripOverviewSubscriptionRequest();
  @override
  List<Object?> get props => [];

}
class InitTripOverview extends TripOverviewEvent{
  const InitTripOverview();

  @override
  List<Object?> get props => [];

}
class IncrementCurrentDay extends TripOverviewEvent{

  const IncrementCurrentDay();
  @override
  List<Object?> get props => [];

}
class DecrementCurrentDay extends TripOverviewEvent{

  const DecrementCurrentDay();
  @override
  List<Object?> get props => [];

}

class SelectDayFinished extends TripOverviewEvent{

  const SelectDayFinished({
    required this.day,
  });
  final DateTime day;

  @override
  List<Object?> get props => [day];
}
