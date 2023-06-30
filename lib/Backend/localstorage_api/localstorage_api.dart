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
      _tripsStreamController.add(const []);
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
    final tripsIndex = trips.indexWhere((t) => t.id == trip.id);
    if (tripsIndex >= 0) {
      final dayIndex = trips[tripsIndex]
          .days
          .indexWhere((element) => element.day == day.day);
      if (dayIndex >= 0) {
        final expendIndex = day.expenditures
            .indexWhere((element) => element.id == expenditure.id);
        if (expendIndex >= 0) {
          trips[tripsIndex].days[dayIndex].expenditures[expendIndex] =
              expenditure;
        } else {
          final expenditures = trips[tripsIndex].days[dayIndex].expenditures.toList()..add(expenditure);
          trips[tripsIndex].days[dayIndex] = trips[tripsIndex].days[dayIndex].copyWith(expenditures: expenditures,);
        }
      }
    } else {
      // Exception??
    }
    _tripsStreamController.add(trips);
    return _setValue(_kTripCollectionKey, json.encode(trips));
  }
}
