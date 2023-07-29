import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:flutter/material.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({required Trip trip, required Repo repo})
      : _repo = repo,
        super(StatsState(trip: trip)) {
    on<Subscription>(_onSubsciptionRequest);
  }
  final Repo _repo;

  Future<void> _onSubsciptionRequest(
      Subscription event, Emitter<StatsState> emit) async {
    await emit.forEach<List<Trip>>(
      _repo.getTrips(),
      onData: (data) {
        emit(state.copyWith(state: StatsStates.loading));
        final tripIndex =
            data.indexWhere((element) => element.id == state.trip.id);
        if (tripIndex >= 0) {
          final tmpTrip = data[tripIndex];
          final parseOnlyCountableExpendituresValue =
              _parseOnlyCountableExpenditures(tmpTrip);
          return state.copyWith(
            state: StatsStates.done,
            trip: data[tripIndex],
            allExpenditures: _parseAllExpenditures(tmpTrip),
            onlyCountableExpenditures: parseOnlyCountableExpendituresValue,
            expendituresPerDay: _parseExpendituresPerDay(
                tmpTrip, parseOnlyCountableExpendituresValue),
            allCategoriesAndExpenditures:
                _parseAllCategoriesAndExpenditures(tmpTrip.expenditures),
            countableCategoriesAndExpenditures:
                _parseCountableCategoriesAndExpenditures(
              tmpTrip.expenditures,
            ),
          );
        } else {
          return state;
        }
      },
    );
  }

  double _parseAllExpenditures(Trip trip) {
    var tmp = 0.0;
    for (final value in trip.expenditures) {
      tmp = tmp + (value.valuePerDay * value.days.length);
    }
    return tmp;
  }

  double _parseOnlyCountableExpenditures(Trip trip) {
    var tmp = 0.0;
    for (final value in trip.expenditures) {
      if (value.directExpenditure) {
        tmp = tmp + (value.valuePerDay * value.days.length);
      }
    }
    return tmp;
  }

  double _parseExpendituresPerDay(Trip trip, double allCountableExpenditures) {
    final day = DateUtils.dateOnly(DateTime.now());
    if (trip.isDayInTripTime(day)) {
      final daysDone = day.difference(trip.startDay).inDays + 1;
      return allCountableExpenditures / daysDone;
    }else if (day.difference(trip.endDay).inDays > 0){
      final daysDone = trip.endDay.difference(trip.startDay).inDays + 1;
      return allCountableExpenditures / daysDone;
    }
    return 0;
  }

  Map<Categories, double> _parseAllCategoriesAndExpenditures(
      List<Expenditure> expenditures) {
    final map = <Categories, double>{};
    if (expenditures.isNotEmpty) {
      for (final element in expenditures) {
        if (map.containsKey(element.category)) {
          map[element.category] = map[element.category]! +
              (element.valuePerDay * element.days.length);
        } else {
          map[element.category] = element.valuePerDay * element.days.length;
        }
      }
    }
    return map;
  }

  Map<Categories, double> _parseCountableCategoriesAndExpenditures(
      List<Expenditure> expenditures) {
    final map = <Categories, double>{};
    if (expenditures.isNotEmpty) {
      for (final element in expenditures) {
        if (element.directExpenditure) {
          if (map.containsKey(element.category)) {
            map[element.category] = map[element.category]! +
                (element.valuePerDay * element.days.length);
          } else {
            map[element.category] = element.valuePerDay * element.days.length;
          }
        }
      }
    }
    return map;
  }
}
