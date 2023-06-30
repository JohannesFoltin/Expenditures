import 'package:expenditures/Frontend/editExpenditure/editExpenditure_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Backend/api/models/trip.dart';
import '../../Backend/repo/repo.dart';
import 'bloc/trip_overview_bloc.dart';

class TripOverview extends StatelessWidget {
  const TripOverview({required this.trip, super.key});

  final Trip trip;
  static MaterialPageRoute<void> route(Trip strip) {
    return MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => TripOverview(trip: strip),);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripOverviewBloc(context.read<Repo>(), trip)
        ..add(const TripOverviewSubscriptionRequest()),
      child: BlocBuilder<TripOverviewBloc, TripOverviewState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(EditExpenditureView.route(
                      state.trip, state.currentSelectedDay));
                }),
            appBar: AppBar(
                leading: const SizedBox.shrink(),
                title: Text(state.currentSelectedDay.day.toString())),
            body: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      int sensitivity = 0;
                      // Swiping in right direction.
                      if (details.primaryVelocity! > sensitivity) {
                        context
                            .read<TripOverviewBloc>()
                            .add(const DecrementCurrentDay());
                      }
                      // Swiping in left direction.
                      if (details.primaryVelocity! < sensitivity) {
                        context
                            .read<TripOverviewBloc>()
                            .add(const IncrementCurrentDay());
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          color: Colors.red,
                          child: Center(
                            child: Text(state.days.length.toString()),
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              for (final expenditure
                                  in state.currentSelectedDay.expenditures)
                                Text(expenditure.name)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
