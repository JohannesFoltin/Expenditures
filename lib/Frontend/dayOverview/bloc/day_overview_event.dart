part of 'day_overview_bloc.dart';

abstract class DayOverviewEvent extends Equatable {
  const DayOverviewEvent();

}
class InitTripOverview extends DayOverviewEvent{
  const InitTripOverview();

  @override
  List<Object?> get props => [];

}
class IncrementCurrentDay extends DayOverviewEvent{

  const IncrementCurrentDay();
  @override
  List<Object?> get props => [];

}
class DecrementCurrentDay extends DayOverviewEvent{

  const DecrementCurrentDay();
  @override
  List<Object?> get props => [];

}

class SelectDayFinished extends DayOverviewEvent{

  const SelectDayFinished({
    required this.day,
  });
  final DateTime day;

  @override
  List<Object?> get props => [day];
}
