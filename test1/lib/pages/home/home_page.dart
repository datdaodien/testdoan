import 'package:flutter/material.dart';
import 'package:test1/pages/home/widgets/home_header.dart';
import 'package:test1/pages/home/widgets/home_list.dart';
import 'package:test1/pages/home/widgets/home_search.dart';

import '../thongbao/confirm_exit.dart';
import '../thongbao/connetinternet.dart';

class HomePage extends StatefulWidget {
   const HomePage({Key? key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return WillPopScope(
      onWillPop: () async => await ConfirmExit(context),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                HomeHeader(),
                SizedBox(height: 20),
                HomeSearch(),
                SizedBox(height: 20),
                Expanded(child:HomeList())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
