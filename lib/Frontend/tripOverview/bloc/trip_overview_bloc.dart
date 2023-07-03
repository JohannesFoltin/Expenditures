import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/repo/repo.dart';

import '../../../Backend/api/models/trip.dart';

part 'trip_overview_event.dart';
part 'trip_overview_state.dart';

class TripOverviewBloc extends Bloc<TripOverviewEvent, TripOverviewState> {
  TripOverviewBloc({required Trip trip,required Repo repo})
      : _repository = repo, super(TripOverviewState(trip: trip)) {
    on<Subscription>(_onSubscription);
  }
  final Repo _repository;
  Future<void> _onSubscription(
      Subscription event, Emitter<TripOverviewState> emit) async {

    await emit.forEach<List<Trip>>(
      _repository.getTrips(),
      onData: (trips) {
        final indexTrip =  trips.indexWhere((element) => element.id == state.trip.id);
        if (indexTrip >= 0) {
          emit(state.copyWith(trip: () => trips[indexTrip]));
          return state;
        }else {
          return state;
        }
      },
      // onError: (_, __) => state.copyWith(
      //   trainingEditorStatus: TrainingOverviewStatus.failure,
      // ),
    );
  }
}
