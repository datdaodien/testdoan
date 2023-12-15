import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/pages/dangnhap/constants.dart';
import 'package:test1/pages/thongbao/loading.dart';
import 'package:test1/pages/dangnhap/widgets/login_form.dart';
import 'package:test1/pages/thongbao/thongbao.dart';
import '../../apps/router/routername.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isShowLoginup = false;
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _animationTextRotate;

  final  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController tkController = TextEditingController();
  TextEditingController mkController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;





//_auth
//           .createUserWithEmailAndPassword(
//             email: tkController.text.toString(),
//             password: mkController.text.toString(),
//           )
//           .then((value) {})
//           .onError((error, stackTrace) {
//         ThongBao().tostMessage(error.toString());
  //   });
  Future<void> handleLogin(BuildContext context) async {
    //ham dk
    if ( await _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _auth
          .signInWithEmailAndPassword(
              email: tkController.text, password: mkController.text.toString())
          .then((value) async {

        final uid =value.user!.uid.toString();

        ThongBao().toastMessage("Bạn đâ đăng nhập thành cô vào tai khoản "+ value.user!.email.toString());
        setState(() {
          isLoading = false;
        });
        Stream<DocumentSnapshot<Map<String, dynamic>>> _getUserDataStream() {
          return FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots();
        }

        DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        String userRole = userData['rool']; // Giả sử trường lưu vai trò là 'role'

        if (userRole == 'user') {
          // Nếu là user, chuyển hướng sang trang Home với dữ liệu người dùng
          //context.goNamed(RouterName.home);
        } else if (userRole == 'admin') {
          // Nếu là admin, chuyển hướng sang trang Admin với dữ liệu người dùng
          context.goNamed(RouterName.home,  );

        }
          // Xử lý trường hợp khác nếu cần
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        ThongBao().toastMessage("Tài khoản hoặc mật khẩu không chính xác ");
        setState(() {
          isLoading = false;
        });
      });

    } else {
    }
  }

  void setUpAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: defaultDuration);
    _animationTextRotate =
        Tween<double>(begin: 0, end: 90).animate(_animationController);
  } //Khởi tạo controller và animations cho việc chuyển đổi

  void updateview() {
    setState(() {
      _isShowLoginup = !_isShowLoginup;
    });
    _isShowLoginup
        ? _animationController.forward()
        : _animationController.reverse();
  } //Cập nhật trạng thái để thay đổi hai màn hinh và kích hoạt animation tương ứng.

  @override
  void initState() {
    // TODO: implement initState
    setUpAnimation();
    super.initState();
  } //Gọi khi StatefulWidget được tạo ra, trong đó chúng ta khởi tạo animation.

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  } //Gọi khi StatefulWidget bị xóa, trong đó chúng ta giải phóng các tài nguyên.

  @override
  Widget build(BuildContext context) {

    final ThemeData customTheme = ThemeData(
      primarySwatch: Colors.blue,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white38,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(
          vertical: defpaultPadding * 1.2,
          // Sử dụng defaultPadding thay vì defpaultPadding
          horizontal:
              defpaultPadding, // Sử dụng defaultPadding thay vì defpaultPadding
        ),
      ),
    );

    final size = MediaQuery.of(context).size;
    return Theme(
      data: customTheme, // Sử dụng customTheme
      //Scaffold là một widget cấu trúc giao diện chứa toàn bộ nội dung.
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // giữ cho màn hinình cố định khi nhập liệu
        //Dùng để xây dựng giao diện dựa trên giá trị animation.
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, __) {
            //Sử dụng để xếp các widget lên nhau.
            return Stack(
              children: [
                //giao diện khởi đầu
                AnimatedPositioned(
                  duration: defaultDuration,
                  width: size.width * 0.88, //88%
                  height: size.height,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: start_bg, // Đặt hình nền
                  ),
                ),
                // dang nhâp
                AnimatedPositioned(
                  duration: defaultDuration,
                  width: size.width * 0.88,
                  //88%
                  height: size.height,
                  left: _isShowLoginup ? size.width * 0.12 : size.width * 0.88,
                  // child: GestureDetector(
                  //   onTap: (){
                  //     setState(() {
                  //       _isShowSignup = !_isShowSignup;
                  //     });
                  //   },
                  child: Container(
                    clipBehavior: Clip.hardEdge, // cat an
                    decoration: login_bg,
                    child: LoginForm(
                      tkController: tkController,
                      mkController: mkController,
                      formKey: _formKey,
                    ),
                  ),
                ),
                // ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  left: 40,
                  right: _isShowLoginup ? size.width * 0.1 : size.width * 0.1,
                  top: size.height * 0.1,
                  child: AnimatedSwitcher(
                    duration: defaultDuration,
                    child: CircleAvatar(
                      radius: 30,
                      //logo
                      child: Image.asset("assets/cvg.jpg"), // Hiển thị logo
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: _isShowLoginup
                      ? size.height / 2 - 150
                      : size.height * 0.3,
                  left: _isShowLoginup ? 0 : size.width * 0.44 - 80,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _isShowLoginup ? 20 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: Transform.rotate(
                      angle: -_animationTextRotate.value * pi / 180,
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          if (_isShowLoginup) {
                            updateview();
                          } else {
                            updateview();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: defpaultPadding * 0.75,
                          ),
                          width: 200,
                          child: Text(
                            "xin chào".toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: !_isShowLoginup
                      ? size.height / 2 - 150
                      : size.height * 0.3,
                  right: _isShowLoginup ? size.width * 0.44 - 100 : 0,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: !_isShowLoginup ? 20 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child:  Transform.rotate(
                      angle: (90 - _animationTextRotate.value) * pi / 180,
                      alignment: Alignment.topRight,
                      child:  InkWell(
                        onTap: () {
                                FocusScope.of(context).unfocus();
                                if (_isShowLoginup) {
                                  handleLogin(context);
                                } else {
                                  updateview();

                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: defpaultPadding - 0.99),
                          width: 210,
                          alignment: Alignment.center,
                          child:  isLoading ? Loading() : Text(
                                  "Đăng Nhập".toUpperCase(),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
