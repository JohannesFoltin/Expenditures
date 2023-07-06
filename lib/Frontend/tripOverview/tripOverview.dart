import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Frontend/dayOverview/dayOverview_View.dart';
import 'package:expenditures/Frontend/tripOverview/bloc/trip_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Backend/repo/repo.dart';

class TripOverviewView extends StatelessWidget {
  const TripOverviewView({super.key});

  static Route<void> route({required Trip trip}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => TripOverviewBloc(
          repo: context.read<Repo>(),
          trip: trip,
        ),
        child: const TripOverviewView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripOverviewBloc, TripOverviewState>(
        builder: (context, state) => const DayOverviewPage(),);
  }
}
