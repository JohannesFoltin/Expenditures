part of 'edit_expenditure_bloc.dart';

abstract class EditExpenditureEvent extends Equatable {
  const EditExpenditureEvent();
}
class NameEdited extends EditExpenditureEvent{
  final String newName;

  @override
  List<Object?> get props => [newName];

  const NameEdited({
    required this.newName,
  });
}

class DescriptionEdited extends EditExpenditureEvent{
  final String newDescription;

  const DescriptionEdited({
    required this.newDescription,
  });

  @override
  List<Object?> get props => [newDescription];
}

class ValueEdited extends EditExpenditureEvent{
  final int newValue;

  @override
  List<Object?> get props => [newValue];

  const ValueEdited({
    required this.newValue,
  });
}

class SwitchedDirectExpenditure extends EditExpenditureEvent{
  @override
  List<Object?> get props => [];
}

class SwitchedPayedWithCard extends EditExpenditureEvent {
  @override
  List<Object?> get props => [];
}

class OnSubmitted extends EditExpenditureEvent{
  @override
  List<Object?> get props => [];

}