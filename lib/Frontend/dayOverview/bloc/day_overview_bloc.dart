import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../Backend/api/models/day.dart';
import '../../../Backend/api/models/trip.dart';
import '../../../Backend/repo/repo.dart';

part 'day_overview_event.dart';
part 'day_overview_state.dart';

class DayOverviewBloc extends Bloc<DayOverviewEvent, DayOverviewState> {
  DayOverviewBloc(Repo repository, Trip trip)
      : _repository = repository,
        super(
          DayOverviewState(
            trip: trip,
            currentSelectedDay: trip.days.first,
            days: trip.days,
          ),
        ) {
    on<IncrementCurrentDay>(_incrementCurrentDay);
    on<DecrementCurrentDay>(_decrementCurrentDay);
    on<SelectDayFinished>(_selectDayFinished);
    on<InitTripOverview>((event, emit) {
      final dayIndex = state.days.indexWhere((element) =>
          DateUtils.isSameDay(element.day, DateTime.now()));
      if (dayIndex >= 0) {
        emit(
          state.copyWith(
              currentSelectedDay: state.days[dayIndex]),
        );
      }
    },);
  }

  final Repo _repository;

  Future<void> _selectDayFinished(
      SelectDayFinished event, Emitter<DayOverviewState> emit) async {

    final dayIndex = state.days.indexWhere((element) =>
        DateUtils.isSameDay(element.day, event.day));
    if (dayIndex >= 0) {
      emit(
        state.copyWith(
            currentSelectedDay: state.days[dayIndex]),
      );
    }
  }

  Future<void> _incrementCurrentDay(
      IncrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final dateIndex =
        state.days.indexWhere((element) => element == state.currentSelectedDay);
    if ((dateIndex >= 0) && (dateIndex < state.days.length)) {
      emit(state.copyWith(currentSelectedDay: state.days[dateIndex + 1]));
    }
  }

  Future<void> _decrementCurrentDay(
      DecrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final dateIndex =
        state.days.indexWhere((element) => element == state.currentSelectedDay);
    if ((dateIndex >= 0) && (dateIndex > 0)) {
      emit(state.copyWith(currentSelectedDay: state.days[dateIndex - 1]));
    }
  }
}
