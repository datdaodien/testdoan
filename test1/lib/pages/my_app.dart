import 'package:flutter/material.dart';
import 'package:test1/apps/router/router.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // final RouterCustom routerCustom = RouterCustom(); thay bang stati final bên router có thể truyền dc
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RouterCustom.router,
      // home: AuthScreen(),

      // home: ProductPage(),
    );

  }

}



