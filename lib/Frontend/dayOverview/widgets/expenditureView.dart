import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Frontend/dayOverview/bloc/day_overview_bloc.dart';
import 'package:expenditures/Frontend/editExpenditure/editExpenditure_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenditureView extends StatelessWidget {
  const ExpenditureView({
    required this.expenditure,
    super.key,
  });

  final Expenditure expenditure;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DayOverviewBloc>().state;
    return GestureDetector(
      onLongPress: () => context
          .read<DayOverviewBloc>()
          .add(DeleteExpenditure(expenditure: expenditure)),
      onTap: () => Navigator.of(context).push(
        EditExpenditureView.route(
          strip: state.trip,
          currentDay: state.currentSelectedDay,
          expenditure: expenditure,
        ),
      ),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 52,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(expenditure.name)),
              Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(expenditure.days.length == 1
                      ? '${expenditure.valuePerDay.toStringAsFixed(2)}€'
                      : '${expenditure.valuePerDay.toStringAsFixed(2)}€ *')),
            ],
          ),
        ),
      ),
    );
  }
}
