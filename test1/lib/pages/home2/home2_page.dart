import 'package:flutter/material.dart';
import 'package:test1/pages/home2/widgets/home_header2.dart';
import 'package:test1/pages/home2/widgets/home_list2.dart';
import 'package:test1/pages/home2/widgets/home_search2.dart';

import '../thongbao/confirm_exit.dart';
import '../thongbao/connetinternet.dart';

class Home2Page extends StatefulWidget {
  const Home2Page({super.key});

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {

  @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return WillPopScope(
      onWillPop: () async => await ConfirmExit(context),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const HomeHeader2(),
                const SizedBox(height: 20),
                const HomeSearch2(),
                const SizedBox(height: 20),
                Expanded(child:HomeList2()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
