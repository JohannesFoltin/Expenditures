import 'package:expenditures/Backend/api/models/day.dart';
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
      builder: (context) => TripOverview(trip: strip),
    );
  }

  Future<DateTime> _dayPicker(BuildContext context, DateTime startDay,
      DateTime startstartDay, DateTime endDay) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDay,
      firstDate: startstartDay,
      lastDate: endDay,
    );
    if (picked != null) {
      return picked;
    } else {
      return startDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripOverviewBloc(context.read<Repo>(), trip)
        ..add(const TripOverviewSubscriptionRequest())
        ..add(const InitTripOverview()),
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
                actions: [
                  IconButton(
                      onPressed: () => context
                          .read<TripOverviewBloc>()
                          .add(SelectDayFinished(day: DateTime.now())),
                      icon: const Icon(Icons.today))
                ],
                title: TextButton(
                    onPressed: () {
                      _dayPicker(context, state.currentSelectedDay.day,
                              state.days.first.day, state.days.last.day)
                          .then((value) => context
                              .read<TripOverviewBloc>()
                              .add(SelectDayFinished(day: value)));
                    },
                    child: Text(state.currentSelectedDay.day.toString()))),
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
                            .add(const IncrementCurrentDay());
                      }
                      // Swiping in left direction.
                      if (details.primaryVelocity! < sensitivity) {
                        context
                            .read<TripOverviewBloc>()
                            .add(const DecrementCurrentDay());
                      }
                    },
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              for (final expenditure
                                  in state.currentSelectedDay.expenditures)
                                Card(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(expenditure.name)),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                  "${expenditure.value}€")),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
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
