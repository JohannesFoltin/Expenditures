import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/stats/bloc/stats_bloc.dart';
import 'package:expenditures/Frontend/tripOverview/cubit/trip_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(
        repo: context.read<Repo>(),
        trip: BlocProvider.of<TripOverviewCubit>(context).state.trip,
      )..add(const Subscription()),
      child: const StatsWidget(),
    );
  }
}

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    super.key,
  });

  int calculateTripDays(Trip trip) {
    final difference = trip.endDay.difference(trip.startDay).inDays;
    return difference + 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Stats'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      color: state.allExpenditures >
                              calculateTripDays(state.trip) * state.trip.dailyLimit
                          ? Colors.red
                          : Colors.green,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          'Gesamt Ausgaben: \n--> ${state.allExpenditures.toStringAsFixed(2)}€'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        'Gesamte Direkte Ausgaben: \n--> ${state.onlyCountableExpenditures.toStringAsFixed(2)}€'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Direkt Geld pro Tag ausgegeben Durchschnittlich:\n--> ${state.expendituresPerDay.toStringAsFixed(2)}€ / ${state.trip.dailyLimit}€'),
                const SizedBox(
                  height: 10,
                ),
                const Text('Ausgaben pro Kategorie'),
                const SizedBox(
                  height: 5,
                ),
                for (final categorie in state.allCategoriesAndExpenditures.keys)
                  Text(
                      '${categorie.name[0].toUpperCase()}${categorie.name.substring(1)}:\n-->  ${state.countableCategoriesAndExpenditures[categorie]?.toStringAsFixed(2)}€ (${state.allCategoriesAndExpenditures[categorie]?.toStringAsFixed(2)}€)'),
              ],
            ),
          ),
        );
      },
    );
  }
}
