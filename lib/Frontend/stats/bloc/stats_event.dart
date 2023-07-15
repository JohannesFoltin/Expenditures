part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
}
class Subscription extends StatsEvent{

  const Subscription();

  @override
  List<Object?> get props => [];
}