import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Backend/localstorage_api/localstorage_api.dart';
import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tripsApi = LocalStorageApi(
    plugin: await SharedPreferences.getInstance(),);

  bootstrap(api: tripsApi);
}