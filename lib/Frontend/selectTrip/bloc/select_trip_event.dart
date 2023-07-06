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
    required this.startDay,
    required this.endDay,
    required this.name,
  });
  final int dailyLimit;
  final DateTime startDay;
  final DateTime endDay;
  final String name;
}
final class DeleteTrip extends SelectTripEvent{

  const DeleteTrip({
    required this.toDeleteTrip,
  });
  final Trip toDeleteTrip;
}