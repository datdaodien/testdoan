import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';
import 'package:test1/pages/vegetable/widgets/vegetable_list.dart';
import 'package:test1/pages/vegetable/widgets/vegetable_search.dart';

import '../../api/uid.dart';
import '../thongbao/connetinternet.dart';

class VegetablePage extends StatefulWidget {
  VegetablePage({super.key});

  @override
  State<VegetablePage> createState() => _VegetablePageState();
}

class _VegetablePageState extends State<VegetablePage> {
  String userRole = UserRole().role;
  final TextEditingController textEditingController = TextEditingController();

  late String searchText = ''; // Giá trị tìm kiếm
  @override
  Widget build(BuildContext context) {

    bool isAdmin = userRole == 'admin';
    print(userRole);
    ConnecInternet.checkInternetConnection();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              VegetableSearch(textEditingController: textEditingController,
                onSearchTextChanged: (value) {
                  setState(() {
                    searchText =
                        value; // Cập nhật giá trị tìm kiếm khi có sự thay đổi
                  });
                },),
              const SizedBox(height: 20),
              Expanded(
                child: VegetableList(keySearch: textEditingController.text),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                context.goNamed(RouterName.addvegetable);
              },
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, //đặt v trí
    );
  }
}
