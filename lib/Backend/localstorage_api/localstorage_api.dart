// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:expenditures/Backend/api/api.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:flutter/material.dart';
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
      _tripsStreamController.add([
        Trip(
          startDay: DateTime(2004, 9, 10),
          endDay: DateTime(2004, 9, 11),
          name: 'Bitte erstelle einen neunen Trip',
        )
      ]);
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
  Future<void> saveExpenditure(Trip trip, Expenditure expenditure) {
    final trips = [..._tripsStreamController.value];
    final tripsIndex = _getTripIndexWithException(trips, trip);
    final expenditureIndex = trips[tripsIndex]
        .expenditures
        .indexWhere((element) => element.id == expenditure.id);
    if(expenditureIndex >= 0){
      trips[tripsIndex].expenditures[expenditureIndex] = expenditure;
    }else{
      trips[tripsIndex] = trips[tripsIndex].copyWith(expenditures: [...trips[tripsIndex].expenditures, expenditure]);
    }
    _tripsStreamController.add(trips);
    return _setValue(_kTripCollectionKey, json.encode(trips));
  }

  @override
  Future<void> deleteExpenditure(Trip trip, Expenditure expenditure) {
    final trips = [..._tripsStreamController.value];
    final tripsIndex = _getTripIndexWithException(trips, trip);
    final expenditureIndex = trips[tripsIndex]
        .expenditures
        .indexWhere((element) => element.id == expenditure.id);

    if(expenditureIndex >= 0){
      trips[tripsIndex] = trips[tripsIndex].copyWith(expenditures: [...trips[tripsIndex].expenditures]..removeAt(expenditureIndex));
    }
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

  @override
  Trip getFirstTrip() {
    final trips = [..._tripsStreamController.value];
    return trips.first;
  }

}
