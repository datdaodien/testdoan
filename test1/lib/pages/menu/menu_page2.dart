import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';

import '../thongbao/confirm_exit.dart';

class MenuPage2 extends StatelessWidget {
  const MenuPage2({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 200),
          ListTile(
            onTap: () {
              context.goNamed(RouterName.home2);
          },
            leading: const Icon(
              // Icons.home, phong cách android
              CupertinoIcons.home,//phong cách iOS
              color: Colors.white,
            ),
            title: const Text(
              'Trang Chủ',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              context.goNamed(RouterName.profile2);
            },
            leading: const Icon(
              CupertinoIcons.profile_circled,
              color: Colors.white,
            ),
            title: const Text(
              'Thông Tin Cá Nhân',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              context.goNamed(RouterName.vegetable2);
            },
            leading: const Icon(
              CupertinoIcons.square_favorites,
              color: Colors.white,
            ),
            title: const Text(
              'Rau Củ',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              context.goNamed(RouterName.dichbenh2);
            },
            leading: const Icon(
              CupertinoIcons.square_favorites,
              color: Colors.white,
            ),
            title: const Text(
              'Dịch Bệnh',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),

          ListTile(
            onTap: () {
              context.goNamed(RouterName.profileadmin2);
            },
            leading: const Icon(
              CupertinoIcons.info,
              color: Colors.white,
            ),
            title: const Text(
              'Thông tin liên hệ',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              context.goNamed(RouterName.home2);
            },
            leading: const Icon(
              CupertinoIcons.settings_solid,
              color: Colors.white,
            ),
            title: const Text(
              'Cài Đặt',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () async => await ConfirmExit(context),
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: const Text(
              'Đăng Xuât',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
