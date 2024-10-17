import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';

part 'edit_expenditure_event.dart';
part 'edit_expenditure_state.dart';

class EditExpenditureBloc
    extends Bloc<EditExpenditureEvent, EditExpenditureState> {
  EditExpenditureBloc({
    required Repo repository,
    required Expenditure? expenditure,
    required Trip trip,
    required DateTime currentDay,
    required Categories? category,
  })  : _repository = repository,
        _trip = trip,
        super(
          EditExpenditureState(
            initialExpenditure: expenditure,
            category: expenditure?.category ?? category ?? Categories.sonstige,
            name: expenditure?.name ?? '',
            description: expenditure?.description ?? '',
            value: expenditure != null
                ? expenditure.valuePerDay * expenditure.days.length
                : 0.0,
            paidWithCard: expenditure?.paidWithCard ?? true,
            directExpenditure: expenditure?.directExpenditure ?? true,
            days: expenditure?.days.length ?? 1,
            currentExpenditureDay: expenditure?.days.first ?? currentDay,
            valuePerDay: expenditure?.valuePerDay ?? 0.0,
          ),
        ) {
    on<NameEdited>(_nameEdited);
    on<DescriptionEdited>(_descriptionEdited);
    on<ValueEdited>(_valueEdited);
    on<SwitchedDirectExpenditure>(_switchedDirectExpenditure);
    on<SwitchedPayedWithCard>(_switchedPayedWithCard);
    on<OnSubmitted>(_onSubmitted);
    on<NewDaysValue>(
      (event, emit) {
        emit(state.copyWith(days: event.newValue));
        emit(state.copyWith(valuePerDay: state.value / state.days));
      },
    );
    on<AddDay>(
      (event, emit) {
        emit(state.copyWith(days: state.days + 1));
        emit(state.copyWith(valuePerDay: state.value / state.days));
      },
    );
    on<SubtractDay>(_onSubtractDay);
  }

  final Repo _repository;
  final Trip _trip;

  Future<void> _onSubtractDay(
      SubtractDay event, Emitter<EditExpenditureState> emit) async {
    if (state.days > 1) {
      emit(state.copyWith(days: state.days - 1));
      emit(state.copyWith(valuePerDay: state.value / state.days));
    }
  }

  Future<void> _nameEdited(
      NameEdited event, Emitter<EditExpenditureState> emit) async {
    emit(state.copyWith(name: event.newName));
  }

  Future<void> _descriptionEdited(
      DescriptionEdited event, Emitter<EditExpenditureState> emit) async {
    emit(state.copyWith(description: event.newDescription));
  }

  Future<void> _valueEdited(
      ValueEdited event, Emitter<EditExpenditureState> emit) async {
    emit(state.copyWith(value: event.newValue));
    emit(state.copyWith(valuePerDay: state.value / state.days));
  }

  Future<void> _switchedDirectExpenditure(SwitchedDirectExpenditure event,
      Emitter<EditExpenditureState> emit) async {
    emit(state.copyWith(directExpenditure: !state.directExpenditure));
  }

  Future<void> _switchedPayedWithCard(
      SwitchedPayedWithCard event, Emitter<EditExpenditureState> emit) async {
    emit(state.copyWith(paidWithCard: !state.paidWithCard));
  }

  Future<void> _onSubmitted(
      OnSubmitted event, Emitter<EditExpenditureState> emit) async {
    final Expenditure expenditure;
    if (state.days == 1) {
      expenditure = Expenditure(
        id: state.initialExpenditure?.id,
        category: state.category,
        name: state.name,
        description: state.description,
        valuePerDay: state.valuePerDay,
        directExpenditure: state.directExpenditure,
        paidWithCard: state.paidWithCard,
        days: [state.currentExpenditureDay],
      );
    } else {
      List<DateTime> days = [];
      for (var i = 0; i < state.days; i++) {
        days.add(state.currentExpenditureDay.add(Duration(days: i)));
      }
      expenditure = Expenditure(
        id: state.initialExpenditure?.id,
        category: state.category,
        name: state.name,
        description: state.description,
        valuePerDay: state.valuePerDay,
        directExpenditure: state.directExpenditure,
        paidWithCard: state.paidWithCard,
        days: days,
      );
    }

    try {
      emit(state.copyWith(status: EditExpenditureStateEnum.done));
      await _repository.saveExpenditure(_trip, expenditure);
    } catch (e) {
      //TODO
    }
  }
}
