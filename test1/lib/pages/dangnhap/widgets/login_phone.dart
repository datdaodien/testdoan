import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/pages/thongbao/loading.dart';
import '../../../api/uid.dart';
import '../../../apps/router/routername.dart';
import '../../thongbao/connetinternet.dart';
import '../../thongbao/thongbao.dart';

class LoginPhone extends StatefulWidget {
  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  CollectionReference storeref = FirebaseFirestore.instance.collection('users');

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";
  bool isLoading = false;

  void resetScreenState() {
    setState(() {
      otpVisibility = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Xác Thực SĐT",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF7F7F7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      child: Image.asset('assets/holding-phone.png'),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 64),
                      child: Text(
                        "Bạn sẽ nhận được mã gồm 6 chữ số để xác minh.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF818181),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Số điện thoại',
                              prefix: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('+84'),
                              ),
                            ),
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                          ),
                          Visibility(
                            child: TextField(
                              controller: otpController,
                              decoration: const InputDecoration(
                                hintText: 'OTP',
                                prefix: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(''),
                                ),
                              ),
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                            ),
                            visible: otpVisibility,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            color: Colors.indigo[900],
                            onPressed: isLoading ? null : () async {
                                    FocusScope.of(context).unfocus();
                                    if (otpVisibility) {
                                      verifyOTP();
                                    } else {
                                      loginWithPhone();
                                    }
                                  },
                            child: isLoading ? Loading()
                                : Text(
                                    otpVisibility ? "Xác Thực" : "Đăng Nhập",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginWithPhone() async {
    String phoneNumber = phoneController.text
        .trim(); // Lấy số điện thoại và loại bỏ khoảng trắng
    QuerySnapshot querySnapshot = await storeref
        .where('sdt', isEqualTo: phoneController.text.toString())
        .where('rool', isEqualTo: 'user')
        .get();
    if (querySnapshot.docs.isEmpty) {
      // Email đã tồn tại trong cơ sở dữ liệu, hiển thị thông báo lỗi và kết thúc quá trình
      ThongBao().toastMessage('Số điện thoại không tồn tại hoặc không có quyền truy cập!');
      setState(() {
        isLoading = false;
      });
      return;
    }else {
      var userData = querySnapshot.docs[0].data();
      if (userData is Map<String, dynamic>) {
        String? uid = userData['uid'] as String?;
        String? role = userData['rool'] as String?;
        if (uid != null) {
          CurrentUser().uid = uid;
          UserRole().role = role!;
          print('UID: $uid');
          // Tiếp tục xử lý với uid ở đây
        }
      }
    }
    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      setState(() {
        isLoading =
            true; // Đặt trạng thái loading là true khi bắt đầu đăng nhập
      });
      await Future.delayed(const Duration(seconds: 1));
      Fluttertoast.showToast(
        msg: phoneNumber.isEmpty
            ? "Vui lòng nhập số điện thoại"
            : "Số điện thoại phải có 10 số",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isLoading =
            false; // Đặt trạng thái loading là true khi bắt đầu đăng nhập
      });
      return;
      // Kết thúc hàm nếu ô số điện thoại trống
    }
    setState(() {
      isLoading = true; // Đặt trạng thái loading là true khi bắt đầu đăng nhập
    });
    await Future.delayed(const Duration(seconds: 2));
    auth.verifyPhoneNumber(
      phoneNumber: "+84" + phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          // context.goNamed(RouterName.home);
          print("Bạn đã đăng nhập thành công vào tài khoản user");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        ThongBao().toastMessage('Chúng tôi đã chặn tất cả các yêu cầu từ thiết bị này do hoạt động bất thường. Hãy thử lại sau.');
        setState(() {
          isLoading = false; // Đặt isLoading là false khi xác thực thành công
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {
          isLoading = false; // Đặt isLoading là false khi xác thực thành công
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);
    setState(() {
      isLoading = true;
    });
    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () async {
        if (user != null) {
          await Future.delayed(const Duration(seconds: 1));
          Fluttertoast.showToast(
            msg: "Bạn đã đăng nhập thành công vào tài khoản user ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          setState(() {
            isLoading = false;
          });
          context.goNamed(RouterName.home2);
        } else {
          await Future.delayed(const Duration(seconds: 1));
          Fluttertoast.showToast(
            msg: "Đăng nhập của bạn không thành công",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          setState(() {
            isLoading = false;
          });
          resetScreenState();
          context.goNamed(RouterName.loginphone);
        }
      },
    );
    setState(() {
      isLoading = false; // Đặt isLoading là false khi xác thực thành công
    });
  }
}
