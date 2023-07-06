import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Backend/api/models/day.dart';
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
    emit(state.copyWith(state: State.loading));

    await emit.forEach<List<Trip>>(
      _repository.getTrips(),
      onData: (trips)  {
        return state.copyWith(
        trips: trips,
        state: State.done
      );}
      // onError: (_, __) => state.copyWith(
      //   trainingEditorStatus: TrainingOverviewStatus.failure,
      // ),
    );
  }

  Future<void> _addTrip(AddTrip event, Emitter<SelectTripState> emit) async {
    List<Day> days = [];
    final difference = event.endDay.difference(event.startDay).inDays;
    for (int i = 0; i <= difference; i++) {
      final day = Day(day: event.startDay.add(Duration(days: i)));
      days.add(day);
    }
    final newTrip = Trip(days: days, dailyLimit: event.dailyLimit);
    _repository.saveTrip(newTrip);
  }

  Future<void> _deleteTrip(
      DeleteTrip event, Emitter<SelectTripState> emit) async {
    _repository.deleteTrip(event.toDeleteTrip);
  }
}
