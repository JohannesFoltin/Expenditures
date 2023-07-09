import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';

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
            currentSelectedDay: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day,),
            expendituresOnCurrentDay:
                trip.getExpenditureOnDay(DateTime.now()),
          ),
        ) {
    on<IncrementCurrentDay>(_incrementCurrentDay);
    on<DecrementCurrentDay>(_decrementCurrentDay);
    on<SelectDayFinished>(_selectDayFinished);
    on<DayOverviewSubscriptionRequest>(_onSubsciptionRequest);
    on<DeleteExpenditure>(_onDeleteExpenditure);
    on<SelectCategory>(_onSelectCategory);
    on<InitCurrentDay>(
      (event, emit) {
        if (!_isDayInTripTime(state.currentSelectedDay)) {
          emit(state.copyWith(
              currentSelectedDay: state.trip.startDay,
              expendituresOnCurrentDay:
                  state.trip.getExpenditureOnDay(state.trip.startDay)));
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
        final tripIndex =
            data.indexWhere((element) => element.id == state.trip.id);
        if (tripIndex >= 1) {
          return state.copyWith(
              dayState: DayState.done,
              trip: data[tripIndex],
              expendituresOnCurrentDay: data[tripIndex]
                  .getExpenditureOnDay(state.currentSelectedDay));
        } else {
          return state.copyWith(dayState: DayState.failure);
        }
      },
    );
  }

  bool _isDayInTripTime(DateTime day) {
    return day.isAfter(state.trip.startDay.subtract(const Duration(days: 1))) &&
        day.isBefore(state.trip.endDay.add(const Duration(days: 1)));
  }

  Future<void> _selectDayFinished(
      SelectDayFinished event, Emitter<DayOverviewState> emit) async {
    if (_isDayInTripTime(event.day)) {
      emit(
        state.copyWith(
          currentSelectedDay: event.day,
          expendituresOnCurrentDay: state.trip.getExpenditureOnDay(event.day),
        ),
      );
    }
  }

  Future<void> _incrementCurrentDay(
      IncrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final nextDay = state.currentSelectedDay.add(const Duration(days: 1));
    if (_isDayInTripTime(nextDay)) {
      emit(
        state.copyWith(
          currentSelectedDay: nextDay,
          expendituresOnCurrentDay: state.trip.getExpenditureOnDay(nextDay),
        ),
      );
    }
  }

  Future<void> _decrementCurrentDay(
      DecrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final nextDay = state.currentSelectedDay.subtract(const Duration(days: 1));
    if (_isDayInTripTime(nextDay)) {
      emit(
        state.copyWith(
          currentSelectedDay: nextDay,
          expendituresOnCurrentDay: state.trip.getExpenditureOnDay(nextDay),
        ),
      );
    }
  }

  Future<void> _onDeleteExpenditure(
      DeleteExpenditure event, Emitter<DayOverviewState> emit) async {
    await _repo.deleteExpenditure(state.trip, event.expenditure);
  }

  Future<void> _onSelectCategory(
      SelectCategory event, Emitter<DayOverviewState> emit) async {
    emit(state.copyWith(selectCategory: !state.selectCategory));
  }
}
