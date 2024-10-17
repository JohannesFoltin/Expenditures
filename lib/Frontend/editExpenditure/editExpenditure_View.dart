import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/editExpenditure/bloc/edit_expenditure_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExpenditureView extends StatelessWidget {
  const EditExpenditureView({super.key});

  static Route<void> route({
    required Trip strip,
    required DateTime currentDay,
    Categories? category,
    Expenditure? expenditure,
  }) {
    return MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => BlocProvider(
              create: (context) => EditExpenditureBloc(
                  repository: context.read<Repo>(),
                  expenditure: expenditure,
                  currentDay: currentDay,
                  trip: strip,
                  category: category),
              child: const EditExpenditureView(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditExpenditureBloc, EditExpenditureState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditExpenditureStateEnum.done,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditExpenditure(),
    );
  }
}

class EditExpenditure extends StatelessWidget {
  const EditExpenditure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditExpenditureBloc, EditExpenditureState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            title: const Text('Ausgabe'),
          ),
          body: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '${state.value.toStringAsFixed(2)}€',
                    prefix: Container(
                        padding: EdgeInsets.only(right: 2),
                        child: const Text('€')),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => context
                      .read<EditExpenditureBloc>()
                      .add(ValueEdited(newValue: double.parse(value))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) => context
                      .read<EditExpenditureBloc>()
                      .add(NameEdited(newName: value)),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name: ${state.name}'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Beschreibung: ${state.description}'),
                  onChanged: (value) => context
                      .read<EditExpenditureBloc>()
                      .add(DescriptionEdited(newDescription: value)),
                ),
                const SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  value: state.directExpenditure,
                  onChanged: (_) => context
                      .read<EditExpenditureBloc>()
                      .add(SwitchedDirectExpenditure()),
                  title: const Text('Direkt ausgegeben'),
                ),
                const SizedBox(width: 10),
                CheckboxListTile(
                  title: const Text('Mit Karte bezahlt'),
                  value: state.paidWithCard,
                  onChanged: (_) => context
                      .read<EditExpenditureBloc>()
                      .add(SwitchedPayedWithCard()),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    '${state.days} Tage, Wert pro Tag: ${state.valuePerDay.toStringAsFixed(2)}€'),
                Slider(
                  value: state.days.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 7, // Beispiel: maximal 7 Tage
                  label: state.days.toString(),
                  onChanged: (double value) {
                    context
                        .read<EditExpenditureBloc>()
                        .add(NewDaysValue(newValue: value.toInt()));
                  },
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Abbrechen')),
                    FilledButton(
                      onPressed: () {
                        context.read<EditExpenditureBloc>().add(OnSubmitted());
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 10),
                          Text('Fertig'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
