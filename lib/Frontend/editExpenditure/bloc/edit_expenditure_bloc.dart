import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/day.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:uuid/uuid.dart';

part 'edit_expenditure_event.dart';
part 'edit_expenditure_state.dart';

class EditExpenditureBloc
    extends Bloc<EditExpenditureEvent, EditExpenditureState> {
  EditExpenditureBloc({
    required Repo repository,
    required Expenditure? expenditure,
    required Day day,
    required Trip trip,
    required Categories? category,
  })  : _repository = repository, _day = day,_trip = trip,
        super(EditExpenditureState(
          initialExpenditure: expenditure,
          category: expenditure?.category ?? category?? Categories.sonstige,
          name: expenditure?.name ?? '',
          description: expenditure?.description ?? '',
          value: expenditure?.value ?? 0,
          paidWithCard: expenditure?.paidWithCard ?? true,
          directExpenditure: expenditure?.directExpenditure ?? true,
          days: expenditure?.days ?? 1
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
    if(state.days == 1) {
      final expenditure = Expenditure(
        id: state.initialExpenditure?.id,
        category: state.category,
        name: state.name,
        description: state.description,
        value: state.value,
        directExpenditure: state.directExpenditure,
        paidWithCard: state.paidWithCard,
      );
      try {
        emit(state.copyWith(status: EditExpenditureStateEnum.done));
        await _repository.saveExpenditure(_trip, _day, expenditure);
      }
      catch (e) {
        //TODO
      }
    }else{
      final id = const Uuid().v4();
      for (int i = 0; i < state.days; i++) {
        final value = state.value / state.days;
        final expenditure = Expenditure(
          id: state.initialExpenditure?.id ?? id,
          category: state.category,
          name: state.name,
          description: state.description,
          value: value,
          directExpenditure: state.directExpenditure,
          paidWithCard: state.paidWithCard,
        );
        try {
          emit(state.copyWith(status: EditExpenditureStateEnum.done));
          await _repository.saveExpenditure(_trip, _day, expenditure);
        }
        catch (e) {
          //TODO
        }
      }
    }
  }
}
