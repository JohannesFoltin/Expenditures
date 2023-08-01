import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/selectTrip/bloc/select_trip_bloc.dart';
import 'package:expenditures/Frontend/selectTrip/createTripCubit/create_trip_cubit.dart';
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
      create: (context) => SelectTripBloc(repository: context.read<Repo>())
        ..add(const SelectTripSubscribtionRequest())
        ..add(CheckFastForward()),
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
    return BlocListener<SelectTripBloc, SelectTripState>(
      listenWhen: (previous, current) =>
          previous.fastForward != current.fastForward,
      listener: (context, state) {
        if (state.fastForward) {
          Navigator.of(context).push(
            TripOverviewView.route(
              trip: context.read<Repo>().getSelectedTrip()!,
            ),
          );
        }
      },
      child: BlocBuilder<SelectTripBloc, SelectTripState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Willkommen 👋'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(SettingsView.route(trips: state.trips));
                    },
                    icon: const Icon(Icons.settings)),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _dayPicker(context, context.read<SelectTripBloc>());
              },
              label: Text("Trip erstellen"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 12),
                      const Center(child: Text('Wähle einen Trip aus:')),
                      const SizedBox(height: 16),
                      ..._tripsListCurrent(
                          state, context.read<SelectTripBloc>())
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text("Vergangende Trips"),
                  children: [
                    SizedBox(
                      height: 300,
                      child: ListView(
                          children: _tripsListOld(
                              state, context.read<SelectTripBloc>())),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _tripsListCurrent(SelectTripState state, SelectTripBloc bloc) {
    var trips = <Trip>[];
    for (var value in state.trips) {
      if (value.endDay.compareTo(DateUtils.dateOnly(DateTime.now())) >= 0) {
        trips.add(value);
      }
    }
    if (trips.isEmpty) {
      return [
        const Text(
            'Derzeit keine Vorhanden. Wie wärs wenn du welche hinzufügst? 😊',
            textAlign: TextAlign.center),
      ];
    }
    return [
      for (final trip in trips) SingleTripWidget(bloc: bloc, trip: trip),
    ];
  }

  List<Widget> _tripsListOld(SelectTripState state, SelectTripBloc bloc) {
    var trips = <Trip>[];
    for (var value in state.trips) {
      if (value.endDay.compareTo(DateUtils.dateOnly(DateTime.now())) < 0) {
        trips.add(value);
      }
    }
    if (trips.isEmpty) {
      return [
        const Text('Wow noch keine in der Vergangenheit? Zeit für Urlaub! ✈️',
            textAlign: TextAlign.center),
      ];
    }
    return [
      for (final trip in trips) SingleTripWidget(bloc: bloc, trip: trip),
    ];
  }

  Future<void> _dayPicker(BuildContext context, SelectTripBloc bloc) async {
    await showDateRangePicker(
            context: context,
            saveText: "Weiter",
            firstDate: DateTime.now().subtract(Duration(days: 100)),
            lastDate: DateTime.now().add(const Duration(days: 10000)),
            confirmText: "Weiter")
        .then((value) => _tripEditor(context, bloc, value!));
  }

  Future<void> _tripEditor(
      BuildContext context, SelectTripBloc bloc, DateTimeRange range) async {
    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return Dialog(
            child: BlocProvider(
          create: (context) => CreateTripCubit(),
          child: BlocBuilder<CreateTripCubit, CreateTripState>(
            builder: (context, state) {
              return Container(
                height: 416,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ListView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Trip erstellen',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text('Name des Trips:'),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            onChanged: (value) =>
                                context.read<CreateTripCubit>().setName(value),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text('Tägliches Limit:'),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            onChanged: (value) => context
                                .read<CreateTripCubit>()
                                .setValuePerDay(int.parse(value)),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                              softWrap: false,
                              'Vom ${DateFormat("dd.MM").format(range.start)} bis ${DateFormat("dd.MM.yyyy").format(range.end)}'),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              range.duration.inDays == 1
                                  ? 'Insgesamt ${range.duration.inDays} Nacht, mit ca. ${state.valuePerDay * range.duration.inDays}€ kosten'
                                  : 'Insgesamt ${range.duration.inDays} Nächte, mit ca. ${state.valuePerDay * range.duration.inDays}€ kosten'),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Abbrechen')),
                              ElevatedButton(
                                  onPressed: state.name.length > 1
                                      ? () {
                                          bloc.add(AddTrip(
                                              dailyLimit: state.valuePerDay,
                                              name: state.name,
                                              range: range));
                                          Navigator.pop(context);
                                        }
                                      : null,
                                  child: const Text('Trip erstellen')),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
      },
    );
  }
}

class SingleTripWidget extends StatelessWidget {
  const SingleTripWidget({
    required this.trip,
    required this.bloc,
    super.key,
  });

  final Trip trip;
  final SelectTripBloc bloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(TripOverviewView.route(trip: trip)),
      onLongPress: () => _buildDeleteDialog(context),
      child: Card(
        child: SizedBox(
          width: double.infinity,
          height: 64,
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              SizedBox(
                  width: 96,
                  child: Text(
                    trip.name,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  )),
              const SizedBox(
                width: 128,
              ),
              SizedBox(
                  width: 128,
                  child: Text(
                    '${DateFormat("dd.MM").format(trip.startDay)} - ${DateFormat("dd.MM.yyyy").format(trip.endDay)}',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildDeleteDialog(BuildContext context) async {
    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 128,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Möchtest du wirlich ${trip.name} löschen?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Abbrechen'),
                    ),
                    TextButton(
                      onPressed: () {
                        bloc.add(DeleteTrip(toDeleteTrip: trip));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Löschen'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
