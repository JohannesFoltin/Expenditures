import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:flutter/material.dart';

import '../../../Backend/api/models/day.dart';
import '../../../Backend/api/models/trip.dart';
import '../../../Backend/repo/repo.dart';

part 'day_overview_event.dart';
part 'day_overview_state.dart';

class DayOverviewBloc extends Bloc<DayOverviewEvent, DayOverviewState> {
  DayOverviewBloc(Repo repo, Trip trip)
      : _repo = repo,
        super(
          DayOverviewState(
            trip: trip,
            currentSelectedDay: trip.days.first,
          ),
        ) {
    on<IncrementCurrentDay>(_incrementCurrentDay);
    on<DecrementCurrentDay>(_decrementCurrentDay);
    on<SelectDayFinished>(_selectDayFinished);
    on<DayOverviewSubscriptionRequest>(_onSubsciptionRequest);
    on<DeleteExpenditure>(_onDeleteExpenditure);
    on<InitTripOverview>(
      (event, emit) {
        final dayIndex = state.trip.days.indexWhere(
            (element) => DateUtils.isSameDay(element.day, DateTime.now()));
        if (dayIndex >= 0) {
          emit(
            state.copyWith(currentSelectedDay: state.trip.days[dayIndex]),
          );
        }
      },
    );
  }

  final Repo _repo;
  Future<void> _onSubsciptionRequest(DayOverviewSubscriptionRequest event,
      Emitter<DayOverviewState> emit) async {
    await emit.forEach<List<Trip>>(
      _repo.getTrips(),
      onData: (data) {
        emit(state.copyWith(dayState: DayState.loading));
        final indTrip =
            data.indexWhere((element) => element.id == state.trip.id);
        if (indTrip >= 0) {
          final dayIndex = data[indTrip].days.indexWhere(
              (element) => element.day == state.currentSelectedDay.day);
          return state.copyWith(
            trip: data[indTrip],
            currentSelectedDay: data[indTrip].days[dayIndex],
            dayState: DayState.done,
          );
        } else {
          return state.copyWith(dayState: DayState.failure);
        }
      },
    );
  }

  Future<void> _selectDayFinished(
      SelectDayFinished event, Emitter<DayOverviewState> emit) async {
    final dayIndex = state.trip.days
        .indexWhere((element) => DateUtils.isSameDay(element.day, event.day));
    if (dayIndex >= 0) {
      emit(
        state.copyWith(currentSelectedDay: state.trip.days[dayIndex]),
      );
    }
  }

  Future<void> _incrementCurrentDay(
      IncrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final dateIndex = state.trip.days
        .indexWhere((element) => element == state.currentSelectedDay);
    if ((dateIndex >= 0) && (dateIndex < state.trip.days.length)) {
      emit(state.copyWith(currentSelectedDay: state.trip.days[dateIndex + 1]));
    }
  }

  Future<void> _decrementCurrentDay(
      DecrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final dateIndex = state.trip.days
        .indexWhere((element) => element == state.currentSelectedDay);
    if ((dateIndex >= 0) && (dateIndex > 0)) {
      emit(state.copyWith(currentSelectedDay: state.trip.days[dateIndex - 1]));
    }
  }

  Future<void> _onDeleteExpenditure(
      DeleteExpenditure event, Emitter<DayOverviewState> emit) async {
    await _repo.deleteExpenditure(
        state.trip, state.currentSelectedDay, event.expenditure);
  }
}
