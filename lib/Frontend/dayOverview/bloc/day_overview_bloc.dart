import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';

import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';

part 'day_overview_event.dart';
part 'day_overview_state.dart';

class DayOverviewBloc extends Bloc<DayOverviewEvent, DayOverviewState> {
  DayOverviewBloc(Repo repo, Trip trip)
      : _repo = repo,
        super(
          DayOverviewState(
            trip: trip,
            currentSelectedDay: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            expendituresOnCurrentDay: trip.getExpendituresOnDay(DateTime.now()),
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
          emit(state.copyWith(dayState: DayState.loading));
          final expendituresOnDay =
              state.trip.getExpendituresOnDay(state.trip.startDay);
          emit(state.copyWith(
              dayState: DayState.done,
              currentSelectedDay: state.trip.startDay,
              categoriesAndExpenditures:
                  _currentExpendituresToMap(expendituresOnDay),
              expendituresOnCurrentDay: expendituresOnDay));
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
        if (tripIndex >= 0) {
          final expenditureOnDay =
              data[tripIndex].getExpendituresOnDay(state.currentSelectedDay);
          print(expenditureOnDay.length.toString());
          return state.copyWith(
              dayState: DayState.done,
              categoriesAndExpenditures:
                  _currentExpendituresToMap(expenditureOnDay),
              trip: data[tripIndex],
              expendituresOnCurrentDay: expenditureOnDay);
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
      final expendituresOnDay = state.trip.getExpendituresOnDay(event.day);
      emit(
        state.copyWith(
          currentSelectedDay: event.day,
          categoriesAndExpenditures:
              _currentExpendituresToMap(expendituresOnDay),
          expendituresOnCurrentDay: expendituresOnDay,
        ),
      );
    }
  }

  Future<void> _incrementCurrentDay(
      IncrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final nextDay = state.currentSelectedDay.add(const Duration(days: 1));
    if (_isDayInTripTime(nextDay)) {
      final expendituresOnDay = state.trip.getExpendituresOnDay(nextDay);
      emit(
        state.copyWith(
          currentSelectedDay: nextDay,
          categoriesAndExpenditures:
              _currentExpendituresToMap(expendituresOnDay),
          expendituresOnCurrentDay: expendituresOnDay,
        ),
      );
    }
  }

  Future<void> _decrementCurrentDay(
      DecrementCurrentDay event, Emitter<DayOverviewState> emit) async {
    final nextDay = state.currentSelectedDay.subtract(const Duration(days: 1));
    if (_isDayInTripTime(nextDay)) {
      final expendituresOnDay = state.trip.getExpendituresOnDay(nextDay);
      emit(
        state.copyWith(
          currentSelectedDay: nextDay,
          categoriesAndExpenditures:
              _currentExpendituresToMap(expendituresOnDay),
          expendituresOnCurrentDay: expendituresOnDay,
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

  Map<Categories, List<Expenditure>> _currentExpendituresToMap(
      List<Expenditure> expenditures) {
    final map = <Categories, List<Expenditure>>{};
    if (expenditures.isNotEmpty) {
      for (final element in expenditures) {
        if (map.containsKey(element.category)) {
          map[element.category]!.add(element);
        } else {
          map[element.category] = [element];
        }
      }
    }
    return map;
  }
}
