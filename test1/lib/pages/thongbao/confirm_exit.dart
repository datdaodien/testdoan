import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';

Future<bool> ConfirmExit(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Xác nhận thoát'),
      content: Text('Bạn có chắc muốn thoát ứng dụng không?'),
      actions: [
        TextButton(
          onPressed: () {
            context.goNamed(RouterName.auth);
            SystemNavigator.pop();
          },
          child: Text('Đồng ý'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Hủy'),
        ),
      ],
    ),
  );
  return false;
}


