import 'package:expenditures/Backend/api/api.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';

import '../api/models/day.dart';

class Repo {
  final Api _tripsApi;

  const Repo({
    required Api api,
  }) : _tripsApi = api;

  Stream<List<Trip>> getTrips() => _tripsApi.getTrips();

  Future<void> deleteTrip(Trip trip) => _tripsApi.deleteTrip(trip);

  Future<void> saveTrip(Trip trip) => _tripsApi.saveTrip(trip);

  Future<void> saveExpenditure(Trip trip, Day day, Expenditure expenditure) =>
      _tripsApi.saveExpenditure(trip, day, expenditure);

  Future<void> deleteExpenditure(Trip trip, Day day, Expenditure expenditure) =>
      _tripsApi.deleteExpenditure(trip, day, expenditure);
}
