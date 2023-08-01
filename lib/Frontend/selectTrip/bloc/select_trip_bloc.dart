import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../Backend/api/models/trip.dart';
import '../../../Backend/repo/repo.dart';

part 'select_trip_event.dart';
part 'select_trip_state.dart';

class SelectTripBloc extends Bloc<SelectTripEvent, SelectTripState> {
  SelectTripBloc(Repo repository)
      : _repository = repository,
        super(const SelectTripState()) {
    on<SelectTripSubscribtionRequest>(_onSubscriptionRequested);
    on<AddTrip>(_addTrip);
    on<DeleteTrip>(_deleteTrip);
  }

  final Repo _repository;

  Future<void> _onSubscriptionRequested(
    SelectTripSubscribtionRequest event,
    Emitter<SelectTripState> emit,
  ) async {
    emit(state.copyWith(state: STState.loading));

    await emit.forEach<List<Trip>>(_repository.getTrips(), onData: (trips) {
      return state.copyWith(trips: trips, state: STState.done);
    }
        // onError: (_, __) => state.copyWith(
        //   trainingEditorStatus: TrainingOverviewStatus.failure,
        // ),
        );
  }

  Future<void> _addTrip(AddTrip event, Emitter<SelectTripState> emit) async {
    final newTrip = Trip(
        startDay: DateUtils.dateOnly(event.range.start),
        endDay: DateUtils.dateOnly(event.range.end),
        name: event.name,
        dailyLimit: event.dailyLimit);
    await _repository.saveTrip(newTrip);
  }

  Future<void> _deleteTrip(
      DeleteTrip event, Emitter<SelectTripState> emit) async {
    await _repository.deleteTrip(event.toDeleteTrip);
  }
}
