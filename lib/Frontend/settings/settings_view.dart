import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static Route<void> route({required List<Trip> trips}) {
    return MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => BlocProvider(
              create: (context) => SettingsBloc(
                repo: context.read<Repo>(),
                trips: trips,
              )..add(Subscribe()),
              child: const SettingsView(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: Column(
            children: [
              const Text(
                  'Wähle einen Trip aus, der direkt gestartet wird: '),
              Text("data"),
              DropdownButton(
                value: state.selectedTrip,
                items: [null,...state.trips]
                    .map<DropdownMenuItem<Trip?>>((Trip? value) {
                  return DropdownMenuItem<Trip?>(
                    value: value,
                    child: Text(
                      value == null ? 'Kein Fast Forward' : value.name,
                    ),
                  );
                }).toList(),
                onChanged: (value) => context
                    .read<SettingsBloc>()
                    .add(SelectTrip(trip: value)),
              )
            ],
          ),
        );
      },
    );
  }
}
