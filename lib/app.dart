import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/tripOverview/tripOverview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({required this.repo, super.key});

  final Repo repo;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
     value: repo,
      child: MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
        TripOverviewView(trip: repo.getFirstTrip()),
    ),
    );
  }
}
