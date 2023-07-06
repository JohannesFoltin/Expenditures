
import 'package:expenditures/Backend/api/models/day.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';

abstract class Api{
  const Api();

  Stream<List<Trip>> getTrips();

  Future<void> saveTrip(Trip trip);

  Future<void> deleteTrip(Trip trip);

  Future<void> saveExpenditure(Trip trip,Day day,Expenditure expenditure);

  Future<void> deleteExpenditure(Trip trip,Day day,Expenditure expenditure);

  Trip getFirstTrip();
}