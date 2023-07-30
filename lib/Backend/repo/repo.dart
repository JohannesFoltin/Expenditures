import 'package:expenditures/Backend/api/api.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/settings.dart';
import 'package:expenditures/Backend/api/models/trip.dart';

class Repo {
  final Api _tripsApi;

  const Repo({
    required Api api,
  }) : _tripsApi = api;

  Stream<List<Trip>> getTrips() => _tripsApi.getTrips();

  Stream<Settings> getSettings() => _tripsApi.getSettings();

  Future<void> deleteTrip(Trip trip) => _tripsApi.deleteTrip(trip);

  Future<void> saveTrip(Trip trip) => _tripsApi.saveTrip(trip);

  Future<void> saveExpenditure(Trip trip, Expenditure expenditure) =>
      _tripsApi.saveExpenditure(trip, expenditure);

  Future<void> deleteExpenditure(Trip trip, Expenditure expenditure) =>
      _tripsApi.deleteExpenditure(trip, expenditure);

  Trip? getSelectedTrip() => _tripsApi.getSelectedTrip();

  Future<void> setTripIDFormSelectedTrip(String? tripId) =>
      _tripsApi.setTripIDFormSelectedTrip(tripId);
}
