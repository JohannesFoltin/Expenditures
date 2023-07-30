
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/settings.dart';
import 'package:expenditures/Backend/api/models/trip.dart';

abstract class Api{
  const Api();

  Stream<List<Trip>> getTrips();

  Stream<Settings> getSettings();

  Future<void> saveTrip(Trip trip);

  Future<void> deleteTrip(Trip trip);

  Future<void> saveExpenditure(Trip trip,Expenditure expenditure);

  Future<void> deleteExpenditure(Trip trip,Expenditure expenditure);

  Trip? getSelectedTrip();

  Future<void> setTripIDFormSelectedTrip(String? tripId);
}
