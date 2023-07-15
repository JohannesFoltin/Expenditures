import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({required Trip trip, required Repo repo})
      : _repo = repo, super(StatsState(trip: trip)) {
    on<Subscription>(_onSubsciptionRequest);
  }
  final Repo _repo;

  Future<void> _onSubsciptionRequest(Subscription event,
      Emitter<StatsState> emit) async {
    await emit.forEach<List<Trip>>(
      _repo.getTrips(),
      onData: (data) {
        emit(state.copyWith(state: StatsStates.loading));
        final tripIndex =
        data.indexWhere((element) => element.id == state.trip.id);
        if (tripIndex >= 0) {
          return state.copyWith(state: StatsStates.done,trip: data[tripIndex]);
        } else {
          return state;
        }
      },
    );
  }
}
