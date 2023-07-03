part of 'trip_overview_bloc.dart';

abstract class TripOverviewEvent extends Equatable {
  const TripOverviewEvent();
}

class Subscription extends TripOverviewEvent{
  const Subscription();

  @override
  List<Object?> get props => [];

}