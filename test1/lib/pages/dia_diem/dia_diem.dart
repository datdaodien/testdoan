import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/pages/dia_diem/widgets/dia_diem_list.dart';
import 'package:test1/pages/dia_diem/widgets/dia_diem_search.dart';
import '../../apps/router/routername.dart';
import '../thongbao/connetinternet.dart';


class DiaDiemPage extends StatefulWidget {
  const DiaDiemPage({super.key});

  @override
  State<DiaDiemPage> createState() => _DiaDiemPageState();
}

class _DiaDiemPageState extends State<DiaDiemPage> {
  final TextEditingController textEditingController = TextEditingController();

  late String searchText = ''; // Giá trị tìm kiếm

  @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              DiaDiemSearch(textEditingController: textEditingController,
                onSearchTextChanged: (value) {
                  setState(() {
                    searchText =
                        value; // Cập nhật giá trị tìm kiếm khi có sự thay đổi
                  });
                },),
              const SizedBox(height: 20),
              Expanded(
                child: DiaDiemList(keySearch: textEditingController.text),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(RouterName.adddiadiem);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, //đặt v trí
    );
  }
}

