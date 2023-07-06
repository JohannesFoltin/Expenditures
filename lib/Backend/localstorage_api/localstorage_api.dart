// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:expenditures/Backend/api/api.dart';
import 'package:expenditures/Backend/api/models/day.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_fitnessfourthausend_api}
/// A Flutter implementation of the TrainingApi that uses local storage.
/// {@endtemplate}
///
///
class LocalStorageApi extends Api {
  /// {@macro local_storage_fitnessfourthausend_api}

  LocalStorageApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }


  final SharedPreferences _plugin;

  final _tripsStreamController = BehaviorSubject<List<Trip>>.seeded(const []);

  static const _kTripCollectionKey = '__trips_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final days = <Day>[Day(day: DateTime.utc(2004,10,09))];
    final tripsJson = _getValue(_kTripCollectionKey);
    if (tripsJson != null) {
      final trips = List<Map<dynamic, dynamic>>.from(
        json.decode(tripsJson) as List,
      )
          .map(
            (jsonMap) => Trip.fromJson(Map<String, dynamic>.from(jsonMap)),
          )
          .toList();
      _tripsStreamController.add(trips);
    } else {
      _tripsStreamController.add([Trip(name:'Bitte erstelle einen neunen Trip',days: days)]);
    }
  }

  @override
  Future<void> deleteTrip(Trip trip) {
    final trips = [..._tripsStreamController.value];
    final tripIndex = trips.indexWhere((t) => t.id == trip.id);
    if (tripIndex >= 0) {
      trips.removeAt(tripIndex);
    }
    _tripsStreamController.add(trips);
    return _setValue(_kTripCollectionKey, json.encode(trips));
  }

  @override
  Stream<List<Trip>> getTrips() => _tripsStreamController.asBroadcastStream();

  @override
  Future<void> saveTrip(Trip trip) {
    final trips = [..._tripsStreamController.value];
    final trainingIndex = trips.indexWhere((t) => t.id == trip.id);
    if (trainingIndex >= 0) {
      trips[trainingIndex] = trip;
    } else {
      trips.add(trip);
    }
    _tripsStreamController.add(trips);
    return _setValue(_kTripCollectionKey, json.encode(trips));
  }

  @override
  Future<void> saveExpenditure(Trip trip, Day day, Expenditure expenditure) {
    final trips = [..._tripsStreamController.value];
    final tripsIndex = _getTripIndexWithException(trips, trip);
    final dayIndex = _getDayIndexWithException(trips[tripsIndex].days, day);
    final expendIndex =
        day.expenditures.indexWhere((element) => element.id == expenditure.id);
    if (expendIndex >= 0) {
      trips[tripsIndex].days[dayIndex].expenditures[expendIndex] = expenditure;
    } else {
      final expenditures = trips[tripsIndex]
          .days[dayIndex]
          .expenditures
          .toList()
        ..add(expenditure);
      trips[tripsIndex].days[dayIndex] =
          trips[tripsIndex].days[dayIndex].copyWith(
                expenditures: expenditures,
              );
    }
    _tripsStreamController.add(trips);
    return _setValue(_kTripCollectionKey, json.encode(trips));
  }

  @override
  Future<void> deleteExpenditure(Trip trip,Day day, Expenditure expenditure){
    final trips = [..._tripsStreamController.value];
    final tripsIndex = _getTripIndexWithException(trips, trip);
    final dayIndex = _getDayIndexWithException(trips[tripsIndex].days, day);
    final expenditureIndex = _getExpenditureIndexWithException(trips[tripsIndex].days[dayIndex].expenditures, expenditure);
    trips[tripsIndex].days[dayIndex].expenditures.removeAt(expenditureIndex);

    _tripsStreamController.add(trips);
    return _setValue(_kTripCollectionKey, json.encode(trips));
  }
  int _getTripIndexWithException(List<Trip> trips, Trip trip) {
    final tripIndex = trips.indexWhere((element) => element.id == trip.id);
    if (tripIndex >= 0) {
      return tripIndex;
    } else {
      throw Exception('Index not Found for Trip');
    }
  }

  int _getDayIndexWithException(List<Day> days, Day day) {
    final dayIndex = days.indexWhere((element) => element.day == day.day);
    if (dayIndex >= 0) {
      return dayIndex;
    } else {
      throw Exception('Index not Found for Trip');
    }
  }

  int _getExpenditureIndexWithException(
      List<Expenditure> expenditures, Expenditure expenditure) {
    final expenditureIndex =
        expenditures.indexWhere((element) => element.id == expenditure.id);
    if (expenditureIndex >= 0) {
      return expenditureIndex;
    } else {
      throw Exception('Index not Found for Trip');
    }
  }

  @override
  Trip getFirstTrip() {
     final trips = [..._tripsStreamController.value];
    return trips.first;
  }
}
