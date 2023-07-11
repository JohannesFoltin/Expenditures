part of 'edit_expenditure_bloc.dart';

enum EditExpenditureStateEnum { onProgress, done, failure }

class EditExpenditureState extends Equatable {
  const EditExpenditureState({
    required this.category,
    required this.currentExpenditureDay, this.initialExpenditure,
    this.status = EditExpenditureStateEnum.onProgress,
    this.name = '',
    this.description = '',
    this.value = 0,
    this.directExpenditure = true,
    this.paidWithCard = true,
    this.days = 1,
    this.valuePerDay = 0,
  });

  final Expenditure? initialExpenditure;
  final Categories category;
  final EditExpenditureStateEnum status;
  final String name;
  final String description;
  final double value;
  final bool directExpenditure;
  final bool paidWithCard;
  final int days;
  final DateTime currentExpenditureDay;
  final double valuePerDay;

  @override
  List<Object?> get props => [
        status,
        initialExpenditure,
        name,
        description,
        value,
        directExpenditure,
        paidWithCard,
        category,
        days,
      currentExpenditureDay,
    valuePerDay,
      ];

  EditExpenditureState copyWith({
    Expenditure? initialExpenditure,
    Categories? category,
    EditExpenditureStateEnum? status,
    String? name,
    String? description,
    double? value,
    bool? directExpenditure,
    bool? paidWithCard,
    int? days,
    DateTime? currentExpenditureDay,
    double? valuePerDay,
  }) {
    return EditExpenditureState(
      initialExpenditure: initialExpenditure ?? this.initialExpenditure,
      category: category ?? this.category,
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
      directExpenditure: directExpenditure ?? this.directExpenditure,
      paidWithCard: paidWithCard ?? this.paidWithCard,
      days: days ?? this.days,
      currentExpenditureDay:
          currentExpenditureDay ?? this.currentExpenditureDay,
      valuePerDay: valuePerDay ?? this.valuePerDay,
    );
  }
}
