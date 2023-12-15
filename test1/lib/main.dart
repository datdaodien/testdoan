import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test1/pages/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/pages/thongbao/connetinternet.dart';


Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  await ConnecInternet.checkInternetConnection();
}
