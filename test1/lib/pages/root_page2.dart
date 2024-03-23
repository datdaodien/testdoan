import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'menu/menu_page2.dart';

// ignore: must_be_immutable menu, must_be_immutable
class RootPage2 extends StatefulWidget {
  Widget child;

  RootPage2({super.key, required this.child});

  @override
  State<RootPage2> createState() => _RootPage2State();
}

class _RootPage2State extends State<RootPage2> {
  ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      style: DrawerStyle.defaultStyle,
      menuScreen: MenuPage2(),
      mainScreen: widget.child,
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,

      // slideWidth: MediaQuery
      //     .of(context)
      //     .size
      //     .width * .65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}
