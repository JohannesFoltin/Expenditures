import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Frontend/dayOverview/dayOverview_View.dart';
import 'package:expenditures/Frontend/stats/stats.dart';
import 'package:expenditures/Frontend/tripOverview/cubit/trip_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripOverviewView extends StatelessWidget {
  const TripOverviewView({ super.key});

 static Route<void> route({required Trip trip}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => TripOverviewCubit(
          trip: trip,
        ),
        child: const TripOverviewView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const TripOverviewPage();
  }
}

class TripOverviewPage extends StatelessWidget {
  const TripOverviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((TripOverviewCubit cubit) => cubit.state.tab);
    return BlocBuilder<TripOverviewCubit, TripOverviewState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: selectedTab.index,
            children: const [DayOverviewPage(), StatsView()],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => context
                      .read<TripOverviewCubit>()
                      .setTab(HomeTab.dayOverview),
                  icon: const Icon(Icons.view_day),
                ),
                IconButton(
                    onPressed: () =>
                        context.read<TripOverviewCubit>().setTab(HomeTab.stats),
                    icon: const Icon(Icons.query_stats))
              ],
            ),
          ),
        );
      },
    );
  }
}
