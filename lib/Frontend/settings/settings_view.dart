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
              repo: context.read<Repo>(), trips: trips,)..add(Subscribe()),
          child: const SettingsView(),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc,SettingsState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.trips.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item: ${state.trips[index].name}'),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },);
  }
}
