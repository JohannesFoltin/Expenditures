part of 'edit_expenditure_bloc.dart';
enum EditExpenditureStateEnum { onProgress, done }

class EditExpenditureState extends Equatable {

  const EditExpenditureState({
    this.initialExpenditure,
    this.status = EditExpenditureStateEnum.onProgress,
    this.name = '',
    this.description = '',
    this.value = 0,
    this.directExpenditure = true,
    this.paidWithCard = true,
  });

  final Expenditure? initialExpenditure;
  final EditExpenditureStateEnum status;
  final String name;
  final String description;
  final int value;
  final bool directExpenditure;
  final bool paidWithCard;

  @override
  List<Object?> get props => [
        status,
        initialExpenditure,
        name,
        description,
        value,
        directExpenditure,
        paidWithCard
      ];

  EditExpenditureState copyWith({
    Expenditure? initialExpenditure,
    EditExpenditureStateEnum? status,
    String? name,
    String? description,
    int? value,
    bool? directExpenditure,
    bool? paidWithCard,
  }) {
    return EditExpenditureState(
      initialExpenditure: initialExpenditure ?? this.initialExpenditure,
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
      directExpenditure: directExpenditure ?? this.directExpenditure,
      paidWithCard: paidWithCard ?? this.paidWithCard,
    );
  }
}
