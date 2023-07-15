import 'package:expenditures/Frontend/dayOverview/bloc/day_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsumendMoneyWidget extends StatelessWidget {
  const ConsumendMoneyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DayOverviewBloc>().state;
    return Container(
      width: double.infinity,
      color: state.getDayExpendituresImportantValue(state.expendituresOnCurrentDay) >
          state.trip.dailyLimit
          ? Colors.red
          : Colors.green,
      child: Center(
        child: Text(
          '${state.getDayExpendituresImportantValue(state.expendituresOnCurrentDay).toStringAsFixed(2)}€ von ${state.trip.dailyLimit}€ verbraucht. (${state.getDayExpendituresAllValue(state.expendituresOnCurrentDay).toStringAsFixed(2)}€)',
        ),
      ),
    );
  }

}
