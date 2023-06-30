import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';

import 'package:expenditures/Backend/api/models/day.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';

part 'edit_expenditure_event.dart';
part 'edit_expenditure_state.dart';

class EditExpenditureBloc
    extends Bloc<EditExpenditureEvent, EditExpenditureState> {
  //TODO Add initExpenditure
  EditExpenditureBloc({
    required Repo repository,
    required Expenditure? expenditure,
    required Day day,
    required Trip trip
  })  : _repository = repository, _day = day,_trip = trip,
        super(EditExpenditureState(
          initialExpenditure: expenditure,
        )) {
    on<NameEdited>(_nameEdited);
    on<DescriptionEdited>(_descriptionEdited);
    on<ValueEdited>(_valueEdited);
    on<SwitchedDirectExpenditure>(_switchedDirectExpenditure);
    on<SwitchedPayedWithCard>(_switchedPayedWithCard);
    on<OnSubmitted>(_onSubmitted);
  }

  final Repo _repository;
  final Day _day;
  final Trip _trip;

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
    final expenditure = Expenditure(
      name: state.name,
      description: state.description,
      value: state.value,
      directExpenditure: state.directExpenditure,
      paidWithCard: state.paidWithCard,
    );
      emit(state.copyWith(status: EditExpenditureStateEnum.done));
      await _repository.saveExpenditure(_trip, _day,expenditure);
  }
}
