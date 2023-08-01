part of 'select_trip_bloc.dart';

abstract class SelectTripEvent{
  const SelectTripEvent();
}
final class SelectTripSubscribtionRequest extends SelectTripEvent{
  const SelectTripSubscribtionRequest();
}
final class AddTrip extends SelectTripEvent{

  const AddTrip({
    required this.dailyLimit,
    required this.name,
    required this.range,
  });
  final int dailyLimit;
  final DateTimeRange range;
  final String name;
}
final class DeleteTrip extends SelectTripEvent{

  const DeleteTrip({
    required this.toDeleteTrip,
  });
  final Trip toDeleteTrip;
}

final class TurnOffFastFoward extends SelectTripEvent{
  const TurnOffFastFoward();
}

final class CheckFastForward extends SelectTripEvent{

}