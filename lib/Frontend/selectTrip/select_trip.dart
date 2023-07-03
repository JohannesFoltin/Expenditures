import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/tripOverview/tripOverview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dayOverview/dayOverview_View.dart';
import 'bloc/select_trip_bloc.dart';

class SelectTrip extends StatelessWidget {
  const SelectTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SelectTripBloc(context.read<Repo>())
          ..add(const SelectTripSubscribtionRequest()),
        child: BlocBuilder<SelectTripBloc, SelectTripState>(
          //TODO Maybe more precise
          buildWhen: (previous, current) =>
              previous.trips.length != current.trips.length,
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (final trip in state.trips)
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(TripOverviewView.route(trip: trip));
                      },
                      onLongPress: () => context
                          .read<SelectTripBloc>()
                          .add(DeleteTrip(toDeleteTrip: trip)),
                      child: Text(
                          "Trip vom ${trip.days.first.day} bis zum ${trip.days.last.day}")),
                TextButton(
                    onPressed: () {
                      context.read<SelectTripBloc>().add(AddTrip(
                          dailyLimit: 75,
                          startDay: DateTime(2023, 06, 22),
                          endDay: DateTime(2023, 07, 20)));
                    },
                    child: const Text("Add Trip")),
              ],
            );
          },
        ),
      ),
    );
  }
}
