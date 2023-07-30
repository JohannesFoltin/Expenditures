import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/settings.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required Repo repo, required List<Trip> trips})
      : _repo = repo,
        super(
            SettingsState(selectedTrip: repo.getSelectedTrip(), trips: trips)) {
    on<Subscribe>(_onSubscriptionRequested);
    on<SelectTrip>(_onSelectTrip);
  }

  final Repo _repo;

  Future<void> _onSubscriptionRequested(
    Subscribe event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(state: State.loading));

    await emit.forEach<Settings>(
      _repo.getSettings(),
      onData: (setting) {
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
    }

    await _repo.setTripIDFormSelectedTrip(null);
  }
}
