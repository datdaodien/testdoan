import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';

import '../../thongbao/connetinternet.dart';

class DoiPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _resetPassword(BuildContext context) async {
    String email = emailController.text.trim();

    // Kiểm tra xem email có đúng định dạng không
    if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showDialog(context, 'Lỗi', 'Vui lòng nhập địa chỉ email hợp lệ.');
      return;
    }
    try {
      // Gửi yêu cầu đặt lại mật khẩu
      await _auth.sendPasswordResetEmail(email: email);
      _showDialog(context, 'Đặt lại email đã gửi', 'Vui lòng kiểm tra email của bạn để đặt lại mật khẩu.');
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          _showDialog(context, 'Lỗi', 'Người dùng không tồn tại.');
        } else {
          _showDialog(context, 'Lỗi', 'Đã xảy ra lỗi: ${error.message}');
        }
      } else {
        _showDialog(context, 'Lỗi', 'Đã xảy ra lỗi: $error');
      }
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _resetPassword(context);
              },
              child: const Text('Đặt lại mật khẩu'),
            ),
            TextButton(onPressed: (){
              context.goNamed(RouterName.auth);
            }, child: const Text('quay lại trang đăng nhập!'))
          ],
        ),
      ),
    );
  }
}