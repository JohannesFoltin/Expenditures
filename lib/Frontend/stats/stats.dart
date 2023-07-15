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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('${state.getAllExpendituresValeues().toStringAsFixed(2)}€'))
            ],
          ),
        );
      },
    );
  }
}
