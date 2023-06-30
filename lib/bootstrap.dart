import 'dart:async';
import 'dart:developer';

import 'package:expenditures/Backend/api/api.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/app.dart';
import 'package:expenditures/app_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

void bootstrap({required Api api}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final repository = Repo(api: api);

  runZonedGuarded(
        () => runApp(MyApp(repo: repository)),
        (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
