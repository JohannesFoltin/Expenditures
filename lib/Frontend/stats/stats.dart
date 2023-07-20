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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Stats"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Gesamt Ausgaben: \n--> ${state.allExpenditures.toStringAsFixed(2)}€'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Gesamte Direkte Ausgaben: \n--> ${state.onlyCountableExpenditures.toStringAsFixed(2)}€'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Geld pro Tag ausgegeben Durschnittlich:\n--> ${state.expendituresPerDay.toStringAsFixed(2)}€'),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'Ausgaben pro Categorie'),
                for (final categorie in state.allCategoriesAndExpenditures.keys)
                  Text(
                      '${categorie.name[0].toUpperCase()}${categorie.name.substring(1)}:\n-->  ${state.countableCategoriesAndExpenditures[categorie]} (${state.allCategoriesAndExpenditures[categorie]})'),
              ],
            ),
          ),
        );
      },
    );
  }
}
