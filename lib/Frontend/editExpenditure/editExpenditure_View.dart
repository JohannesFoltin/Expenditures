import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Backend/api/models/day.dart';
import '../../Backend/api/models/trip.dart';
import '../../Backend/repo/repo.dart';
import 'bloc/edit_expenditure_bloc.dart';

class EditExpenditureView extends StatelessWidget {
  const EditExpenditureView({super.key, required this.day, required this.trip});
  final Day day;
  final Trip trip;

  static Route<void> route(Trip strip, Day day) {
    return MaterialPageRoute<void>(
        builder: (_) => EditExpenditureView(
              trip: strip,
              day: day,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditExpenditureBloc(
          repository: context.read<Repo>(),
          expenditure: null,
          day: day,
          trip: trip),
      child: BlocListener<EditExpenditureBloc, EditExpenditureState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditExpenditureStateEnum.done,
        listener: (context, state) => Navigator.of(context).pop(),
        child: BlocBuilder<EditExpenditureBloc, EditExpenditureState>(
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: [
                  Text("Name: ${state.name}"),
                  TextField(
                    onChanged: (value) => context
                        .read<EditExpenditureBloc>()
                        .add(NameEdited(newName: value)),
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                  Text("Beschreibung: ${state.description}"),
                  TextField(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) => context
                        .read<EditExpenditureBloc>()
                        .add(DescriptionEdited(newDescription: value)),
                  ),
                  Text("Value: ${state.value}"),
                  TextField(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => context
                        .read<EditExpenditureBloc>()
                        .add(ValueEdited(newValue: int.parse(value))),
                  ),
                  const Text("Direct bezahlt?"),
                  Switch(
                    value: state.directExpenditure,
                    onChanged: (_) => context
                        .read<EditExpenditureBloc>()
                        .add(SwitchedDirectExpenditure()),
                  ),
                  const Text("Mit Karte bezahlt?"),
                  Switch(
                    value: state.paidWithCard,
                    onChanged: (_) => context
                        .read<EditExpenditureBloc>()
                        .add(SwitchedPayedWithCard()),
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<EditExpenditureBloc>().add(OnSubmitted());
                      },
                      child: const Text('Submit'),)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
