
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/selectTrip/bloc/select_trip_bloc.dart';
import 'package:expenditures/Frontend/settings/settings_view.dart';
import 'package:expenditures/Frontend/tripOverview/tripOverview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
    initializeDateFormatting('de');
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
              _dayPicker(context, context.read<SelectTripBloc>());
            },
            label: Text("Trip erstellen"),
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

  void _dayPicker(BuildContext context, SelectTripBloc bloc) async {
    await showDateRangePicker(
            context: context,
            saveText: "Weiter",
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 10000)),
            confirmText: "Weiter")
        .then((value) => _tripEditor(context, bloc, value!));
  }

  void _tripEditor(
      BuildContext context, SelectTripBloc bloc, DateTimeRange range) async {
    var name = '';
    var dailyLimit = 0;

    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return Dialog(
            child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Trip Übersicht',
                style: TextStyle(fontSize: 22),
              ),
              const Text('Name des Trips:'),
              TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const Text("Tägliches Limit:"),
              TextField(
                onChanged: (value) => dailyLimit = int.parse(value),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              Text('Vom:\n${DateFormat("dd.MM.yyyy").format(range.start)}'),
              Text('Bis:\n${DateFormat("dd.MM.yyyy").format(range.end)}'),
              Text('Insgesamt ${range.duration.inDays} Nächte'),
              //TODO Feature: expenditures forecast (dailylimit*days)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Abbrechen')),
                  TextButton(
                      onPressed: () {
                        bloc.add(AddTrip(
                            dailyLimit: dailyLimit, name: name, range: range));
                        Navigator.pop(context);
                      },
                      child: const Text('Trip erstellen')),
                ],
              )
            ],
          ),
        ));
      },
    );
  }
}
