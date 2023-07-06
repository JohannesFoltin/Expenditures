import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/dayOverview/bloc/day_overview_bloc.dart';
import 'package:expenditures/Frontend/editExpenditure/editExpenditure_View.dart';
import 'package:expenditures/Frontend/tripOverview/bloc/trip_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayOverviewPage extends StatelessWidget {
  const DayOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DayOverviewBloc(
        context.read<Repo>(),
        BlocProvider.of<TripOverviewBloc>(context).state.trip,
      )
        ..add(const InitTripOverview())
        ..add(const DayOverviewSubscriptionRequest()),
      child: const DayOverview(),
    );
  }
}

class DayOverview extends StatelessWidget {
  const DayOverview({super.key});

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
    return BlocBuilder<DayOverviewBloc, DayOverviewState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(EditExpenditureView.route(
                    day: state.currentSelectedDay, strip: state.trip));
              }),
          appBar: AppBar(
              leading: const SizedBox.shrink(),
              actions: [
                IconButton(
                    onPressed: () => context
                        .read<DayOverviewBloc>()
                        .add(SelectDayFinished(day: DateTime.now())),
                    icon: const Icon(Icons.today))
              ],
              title: TextButton(
                  onPressed: () {
                    _dayPicker(context, state.currentSelectedDay.day,
                            state.trip.days.first.day, state.trip.days.last.day)
                        .then((value) => context
                            .read<DayOverviewBloc>()
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
                          .read<DayOverviewBloc>()
                          .add(const DecrementCurrentDay());
                    }
                    // Swiping in left direction.
                    if (details.primaryVelocity! < sensitivity) {
                      context
                          .read<DayOverviewBloc>()
                          .add(const IncrementCurrentDay());
                    }
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              if (state.currentSelectedDay.expenditures.isEmpty)
                                const Center(child: Text('keine Ausgaben :)'))
                              else
                                for (final expenditure
                                    in state.currentSelectedDay.expenditures)
                                  ExpenditureView(expenditure: expenditure)
                            ],
                          ),
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
    );
  }
}

class ExpenditureView extends StatelessWidget {
  const ExpenditureView({
    required this.expenditure, super.key,
  });

  final Expenditure expenditure;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DayOverviewBloc>().state;
    return GestureDetector(
      onLongPress: () => context
          .read<DayOverviewBloc>()
          .add(DeleteExpenditure(
              expenditure: expenditure)),
      onTap: () => Navigator.of(context).push(
        EditExpenditureView.route(
          strip: state.trip,
          day: state.currentSelectedDay,
          expenditure: expenditure,
        ),
      ),
      child: Card(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Center(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding:
                        const EdgeInsets.only(
                            left: 15),
                    child:
                        Text(expenditure.name)),
                Container(
                    padding:
                        const EdgeInsets.only(
                            right: 15),
                    child: Text(
                        "${expenditure.value}€")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}