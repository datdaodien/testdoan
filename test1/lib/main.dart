import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test1/api/apis.dart';
import 'package:test1/pages/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/pages/thongbao/connetinternet.dart';

import 'api/shared_preferences.dart';
import 'firebase_options.dart';


Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initSharedPreferences();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ConnecInternet.checkInternetConnection();
  FirebaseApi().initNotifications();
  // GoogleApiAvailability.makeGooglePlayServicesAvailable();
  runApp(const MyApp());

}
