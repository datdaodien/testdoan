import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';
import 'package:test1/pages/vegetable/widgets/vegetable_list.dart';
import 'package:test1/pages/vegetable/widgets/vegetable_search.dart';

class DichBenhPage extends StatelessWidget {
  const DichBenhPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              VegetableSearch(),
              SizedBox(height: 20),
              Expanded(
                  child: VegetableList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            context.goNamed(RouterName.adddichbenh);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,//đặt v trí
    );
  }
}
