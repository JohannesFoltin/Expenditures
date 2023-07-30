import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/selectTrip/bloc/select_trip_bloc.dart';
import 'package:expenditures/Frontend/settings/settings_view.dart';
import 'package:expenditures/Frontend/tripOverview/tripOverview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTrip extends StatelessWidget {
  const SelectTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectTripBloc(context.read<Repo>())
        ..add(const SelectTripSubscribtionRequest()),
      child: const SelectTripView(),
    );
  }
}

class SelectTripView extends StatelessWidget {
  const SelectTripView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectTripBloc, SelectTripState>(
      buildWhen: (previous, current) =>
          previous.trips.length != current.trips.length,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Willkommen'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(SettingsView.route(trips: state.trips));
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.read<SelectTripBloc>().add(AddTrip(
                  name: 'Interrail 2023',
                  dailyLimit: 75,
                  startDay: DateTime(2023, 06, 22),
                  endDay: DateTime(2023, 07, 20)));
            },
            label: Text("Add Trip"),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Column(
            children: [
              const Center(
                  child: Text('Bitte wähle einen der folgenden Trips aus:')),
              for (final trip in state.trips)
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(TripOverviewView.route(trip: trip));
                    },
                    onLongPress: () => context
                        .read<SelectTripBloc>()
                        .add(DeleteTrip(toDeleteTrip: trip)),
                    child: Text(trip.name)),
            ],
          ),
        );
      },
    );
  }
}
