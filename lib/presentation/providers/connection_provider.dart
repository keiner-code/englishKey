import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectionProvider = StreamProvider<bool>((ref) async* {
  await for (final result in Connectivity().onConnectivityChanged) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      final hasInternet = await InternetConnection().hasInternetAccess;
      yield hasInternet;
    } else {
      yield false;
    }
  }
});

final connectionMessageProvider = StateProvider<String?>((ref) => null);
