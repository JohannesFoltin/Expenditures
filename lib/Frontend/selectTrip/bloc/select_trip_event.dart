part of 'select_trip_bloc.dart';

abstract class SelectTripEvent{
  const SelectTripEvent();
}
final class SelectTripSubscribtionRequest extends SelectTripEvent{
  const SelectTripSubscribtionRequest();
}
final class AddTrip extends SelectTripEvent{
  final int dailyLimit;
  final DateTime startDay;
  final DateTime endDay;

  const AddTrip({
    required this.dailyLimit,
    required this.startDay,
    required this.endDay,
  });
}
final class DeleteTrip extends SelectTripEvent{
  final Trip toDeleteTrip;

  const DeleteTrip({
    required this.toDeleteTrip,
  });
}