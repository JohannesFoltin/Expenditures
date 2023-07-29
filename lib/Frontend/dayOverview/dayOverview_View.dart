import 'dart:math';

import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/dayOverview/bloc/day_overview_bloc.dart';
import 'package:expenditures/Frontend/editExpenditure/editExpenditure_View.dart';
import 'package:expenditures/Frontend/tripOverview/cubit/trip_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'widgets/widgets.dart';

class DayOverviewPage extends StatelessWidget {
  const DayOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DayOverviewBloc(
        context.read<Repo>(),
        BlocProvider.of<TripOverviewCubit>(context).state.trip,
      )
        ..add(const DayOverviewSubscriptionRequest())
        ..add(const InitCurrentDay()),
      child: const DayOverview(),
    );
  }
}

class DayOverview extends StatelessWidget {
  const DayOverview({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de');
    return BlocListener<DayOverviewBloc, DayOverviewState>(
      listenWhen: (previous, current) => current.selectCategory == true,
      listener: (context, state) {
        final bloc = BlocProvider.of<DayOverviewBloc>(context);
        _categoriesSelector(context, bloc, state)
            .then((value) => bloc.add(const SelectCategory()));
      },
      child: BlocBuilder<DayOverviewBloc, DayOverviewState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => context
                    .read<DayOverviewBloc>()
                    .add(const SelectCategory())),
            appBar: AppBar(
                leading: const SizedBox.shrink(),
                actions: [
                  IconButton(
                      onPressed: () => context
                          .read<DayOverviewBloc>()
                          .add(SelectDayFinished(day: DateTime.now())),
                      icon: const Icon(Icons.today))
                ],
                centerTitle: true,
                title: TextButton(
                    onPressed: () {
                      _dayPicker(context, state.currentSelectedDay,
                              state.trip.startDay, state.trip.endDay)
                          .then((value) => context
                              .read<DayOverviewBloc>()
                              .add(SelectDayFinished(day: value)));
                    },
                    child: Text(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        "${DateFormat.EEEE("de").format(state.currentSelectedDay)} ${DateFormat("dd.MM.yyyy").format(state.currentSelectedDay)}"))),
            body: Column(
              children: [
                const ConsumendMoneyWidget(),
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      var sensitivity = 0;
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
                                if (state.expendituresOnCurrentDay.isEmpty)
                                  const Center(child: Text('keine Ausgaben :)'))
                                else
                                  for (final categorie in state
                                      .categoriesAndExpenditures.entries)
                                    Card(
                                      child: ExpansionTile(
                                        //Workaround so every Tile is collapse
                                        //while changing Sites
                                        key: Key(
                                            Random().nextDouble().toString()),
                                        title: Text(
                                            '${categorie.key.name[0].toUpperCase()}${categorie.key.name.substring(1)} ${state.getDayExpendituresAllValue(categorie.value).toStringAsFixed(2)}€'),
                                        children: [
                                          for (final expenditure
                                              in categorie.value)
                                            ExpenditureView(
                                              expenditure: expenditure,
                                            )
                                        ],
                                      ),
                                    )
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
      ),
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

  Future<dynamic> _categoriesSelector(
      BuildContext context, DayOverviewBloc bloc, DayOverviewState state) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        _done(context, bloc, state, Categories.essen);
                      },
                      child: const Text('Essen')),
                  TextButton(
                      onPressed: () {
                        _done(context, bloc, state, Categories.transport);
                      },
                      child: const Text('Transport')),
                  TextButton(
                      onPressed: () {
                        _done(context, bloc, state, Categories.lebensmittel);
                      },
                      child: const Text('Lebensmittel')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        _done(context, bloc, state, Categories.schlafen);
                      },
                      child: const Text('Schlafen')),
                  TextButton(
                      onPressed: () {
                        _done(context, bloc, state, Categories.aktivitaeten);
                      },
                      child: const Text('Aktivitäten')),
                  TextButton(
                      onPressed: () {
                        _done(context, bloc, state, Categories.sonstige);
                      },
                      child: const Text('Sonstiges')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _done(BuildContext context, DayOverviewBloc bloc, DayOverviewState state,
      Categories category) {
    Navigator.of(context).pop();
    Navigator.of(context).push(EditExpenditureView.route(
        currentDay: state.currentSelectedDay,
        strip: state.trip,
        category: category));
  }
}
