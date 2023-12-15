import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/pages/thongbao/thongbao.dart';
import '../../../apps/router/routername.dart';
import '../constants.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController tkController;
  final TextEditingController mkController;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.tkController,
    required this.mkController,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscured = true;

  Future<bool> checkEmailExists(String email) async {
    try {
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods != null && signInMethods.isNotEmpty) {
        // Email tồn tại trong hệ thống
        return true;
        // Thực hiện các hành động tiếp theo ở đây
      } else {
        // Email không tồn tại trong hệ thống
        ThongBao().toastMessage('Tài khoản không tồn tại');
        // Hiển thị thông báo hoặc xử lý tùy thuộc vào trường hợp của bạn
        return false;
      }
    } catch (e) {
      print('Lỗi: $e');
      return false; // Trả về false nếu có lỗi xảy ra
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.12,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            TextFormField(
              cursorRadius: const Radius.circular(200),
              controller: widget.tkController,
              decoration: const InputDecoration(
                hintText: "Tài Khoản",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tài khoản';
                }  else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Vui lòng nhập địa chỉ email hợp lệ';
                }else {
                  checkEmailExists(widget.tkController.toString());
                  // Thực hiện kiểm tra email và xử lý dựa trên kết quả ở đây
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defpaultPadding),
              child: TextFormField(
                controller: widget.mkController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  hintText: "Mật khẩu",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == '123456' ) {
                   context.goNamed(RouterName.doipassworrd);
                   return 'Vui lòng đổi mật khẩu';
                  } else
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }else if (value.length < 6) {
                    return 'Mật khẩu phải chứa ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
            ),
            //else if (value.length < 6) {
            //                     return 'Mật khẩu phải chứa ít nhất 6 ký tự';
            //                   } else if (!value.contains(RegExp(r'[A-Z]'))) {
            //                     return 'Mật khẩu phải chứa ít nhất một chữ cái in hoa';
            //                   } else if (!value.contains(RegExp(r'[0-9]'))) {
            //                     return 'Mật khẩu phải chứa ít nhất một chữ số';
            //                   }
            TextButton(
              onPressed: () {
                context.goNamed(RouterName.forgotpassword);
              },
              child: const Text(
                "Quên Mật Khẩu?",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Spacer(flex: 1),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Divider(color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "hoặc đăng nhập bằng",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Flexible(
                  child: Divider(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                context.goNamed(RouterName.loginphone);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(59),
                    border: Border.all(color: Colors.white)),
                child: const Center(
                  child: Text(
                    "Đăng Nhâp Bằng SDT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
