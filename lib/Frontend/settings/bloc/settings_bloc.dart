import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/settings.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:share_plus/share_plus.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required Repo repo, required List<Trip> trips})
      : _repo = repo,
        super(
            SettingsState(selectedTrip: repo.getSelectedTrip(), trips: trips)) {
    on<Subscribe>(_onSubscriptionRequested);
    on<SelectTrip>(_onSelectTrip);
    on<ExportTrips>(_onExportTrips);
  }

  final Repo _repo;

  Future<void> _onSubscriptionRequested(
    Subscribe event,
    Emitter<SettingsState> emit,
  ) async {
    await emit.forEach<Settings>(
      _repo.getSettings(),
      onData: (setting) {
        emit(state.copyWith(state: State.loading));
        return state.copyWith(
          selectedTrip: _repo.getSelectedTrip(),
          state: State.done,
        );
      },
    );
  }

  Future<void> _onSelectTrip(
    SelectTrip event,
    Emitter<SettingsState> emit,
  ) async {
    if (event.trip != null) {
      await _repo.setTripIDFormSelectedTrip(event.trip!.id);
      return;
    }

    await _repo.setTripIDFormSelectedTrip(null);
  }

  FutureOr<void> _onExportTrips(ExportTrips event, Emitter<SettingsState> emit) async{
      final tmp = await _repo.exportTrips() ?? "No trips to export";
      await Share.share(tmp);
  }
}
