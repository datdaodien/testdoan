import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';
import 'package:test1/pages/dichbenh/widgets/dich_benh_list.dart';
import 'package:test1/pages/dichbenh/widgets/dich_benh_search.dart';


import '../../api/uid.dart';

class DichBenhPage extends StatefulWidget {
   DichBenhPage({super.key});

  @override
  State<DichBenhPage> createState() => _DichBenhPageState();
}

class _DichBenhPageState extends State<DichBenhPage> {
  String userRole = UserRole().role;
  final TextEditingController textEditingController = TextEditingController();

  late String searchText = '';
  @override
  Widget build(BuildContext context) {

    bool isAdmin = userRole == 'admin';
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              DichBenhSearch(textEditingController: textEditingController,
                onSearchTextChanged: (value) {
                  setState(() {
                    searchText =
                        value; // Cập nhật giá trị tìm kiếm khi có sự thay đổi
                  });
                },),
              SizedBox(height: 20),
              Expanded(
                  child: DichBenhList(keySearch: textEditingController.text),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:isAdmin? FloatingActionButton(
        onPressed: () {
            context.goNamed(RouterName.adddichbenh);
        },
        child: Icon(Icons.add),
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,//đặt v trí
    );
  }
}
