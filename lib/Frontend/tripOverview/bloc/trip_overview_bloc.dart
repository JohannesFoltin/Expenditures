import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Backend/api/models/day.dart';
import '../../../Backend/api/models/trip.dart';
import '../../../Backend/repo/repo.dart';

part 'trip_overview_event.dart';
part 'trip_overview_state.dart';

class TripOverviewBloc extends Bloc<TripOverviewEvent, TripOverviewState> {
  TripOverviewBloc(Repo repository, Trip trip)
      : _repository = repository,
        super(
          TripOverviewState(
            trip: trip,
            currentSelectedDay: trip.days.first,
            days: trip.days,
          ),
        ) {
    on<IncrementCurrentDay>(_incrementCurrentDay);
    on<DecrementCurrentDay>(_decrementCurrentDay);
    on<TripOverviewSubscriptionRequest>(_onSubscriptionRequested);
  }

  final Repo _repository;

  Future<void> _onSubscriptionRequested(
    TripOverviewSubscriptionRequest event,
    Emitter<TripOverviewState> emit,
  ) async {
    await emit.forEach<List<Trip>>(
      _repository.getTrips(),
      onData: (trips) {
        final indexTrip =
            trips.indexWhere((element) => element.id == state.trip.id);
        if (indexTrip >= 0) {
          return state.copyWith(days: trips[indexTrip].days);
        }
        return state;
      },
      // onError: (_, __) => state.copyWith(
      //   trainingEditorStatus: TrainingOverviewStatus.failure,
      // ),
    );
  }

  Future<void> _incrementCurrentDay(
      IncrementCurrentDay event, Emitter<TripOverviewState> emit) async {
    final dateIndex =
        state.days.indexWhere((element) => element == state.currentSelectedDay);
    if ((dateIndex >= 0) && (dateIndex < state.days.length)) {
      emit(state.copyWith(currentSelectedDay: state.days[dateIndex + 1]));
    }
  }

  Future<void> _decrementCurrentDay(
      DecrementCurrentDay event, Emitter<TripOverviewState> emit) async {
    final dateIndex =
        state.days.indexWhere((element) => element == state.currentSelectedDay);
    if ((dateIndex >= 0) && (dateIndex > 0)) {
      emit(state.copyWith(currentSelectedDay: state.days[dateIndex - 1]));
    }
  }
}
