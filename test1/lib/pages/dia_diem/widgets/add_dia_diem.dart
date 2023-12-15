import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/apps/router/routername.dart';
import '../../thongbao/connetinternet.dart';
import '../../thongbao/loading.dart';
import '../../thongbao/thongbao.dart';
import 'package:intl/intl.dart';
import 'package:fast_contacts/fast_contacts.dart';

class AddDiaDiem extends StatefulWidget {
  @override
  _AddDiaDiemState createState() => _AddDiaDiemState();
}

class _AddDiaDiemState extends State<AddDiaDiem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isAs = false;

  final TextEditingController tkController = new TextEditingController();
  final TextEditingController mkController = new TextEditingController();

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController tuoiController = new TextEditingController();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController diachiController = new TextEditingController();
  final TextEditingController sdtController = new TextEditingController();
  final contacts = FastContacts.getAllContacts();
  File? _imageFile;
  ImagePicker picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  final _auth = FirebaseAuth.instance;
  CollectionReference storeref = FirebaseFirestore.instance.collection('users');

  Future<String> signUp() async {
    setState(() {
      isLoading = true;
    });
    // Kiểm tra xem email đã tồn tại trong Firestore hay chưa
    QuerySnapshot querySnapshot = await storeref
        .where('email', isEqualTo: emailController.text.toString())
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Email đã tồn tại trong cơ sở dữ liệu, hiển thị thông báo lỗi và kết thúc quá trình
      ThongBao().toastMessage('Email đã tồn tại!');
      setState(() {
        isLoading = false;
      });
      return '';
    }

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: '123456',
    );
    String uid = userCredential.user!.uid;
    if (uid.isNotEmpty) {
      print('Tạo người dùng thành công! UID: $uid');
      return uid;
      // Nếu có UID, không cần xuất thông báo ở đây
    } else {
      setState(() {
        isLoading = false;
      });
      throw 'Không thể tạo người dùng';
    }
  }

  void Firestore(uid, newUrl) async {
    setState(() {
      isLoading = true;
    });
    await storeref.doc(uid).set({
      'hinh': newUrl.toString(),
      'name': nameController.text.toString(),
      'tuoi': tuoiController.text.toString(),
      'email': emailController.text.toString(),
      'sdt': sdtController.text.toString(),
      'uid': uid,
      'diachi': diachiController.text.toString(),
      'rool': "user",
    }).then((value) async {
      setState(() {
        isLoading = false;
      });
      ThongBao().toastMessage('Tạo người dùng thành công!');
      context.goNamed(RouterName.diadiem);

      setState(() {
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      ThongBao().toastMessage('Đã xảy ra một số lỗi!');
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Thêm Users'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Chọn từ thư viện'),
                                onTap: () {
                                  _getImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_camera),
                                title: Text('Chụp ảnh mới'),
                                onTap: () {
                                  _getImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white70,
                        width: 2.0,
                      ),
                    ),
                    child: _imageFile != null
                        ? Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Icon(Icons.add_a_photo, size: 50),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Tên',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.person), // Icon cho Tên
                      //,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 14.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    if (value.isEmpty && isAs) {
                      // Nếu người dùng xóa
                      isAs = false; // Đặt cờ lại về false
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: tuoiController,
                  // initialValue:,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Ngày tháng năm sinh ',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.date_range), // Icon cho Tên
                      //,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 14.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          final formattedDate =
                              DateFormat('dd/MM/yyyy').format(selectedDate);
                          tuoiController.text = formattedDate;
                        }
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                  ),
                  validator: (value) {
                    final datePattern =
                        r'^\d{2}/\d{2}/\d{4}$'; // Định dạng dd/mm/yyyy
                    final validDate = RegExp(datePattern).hasMatch(value ?? '');

                    if (value == null || value.isEmpty) {
                      return 'vui lòng ngày tháng năm';
                    }
                    if (!validDate) {
                      return 'Định dạng ngày tháng không đúng (dd/mm/yyyy)';
                    } else {
                      final dateParts = value.split('/');
                      final day = int.parse(dateParts[0]);
                      final month = int.parse(dateParts[1]);
                      final year = int.parse(dateParts[2]);
                      final now = DateTime.now();

                      if (year > now.year || year < 1900) {
                        return 'Năm không hợp lệ';
                      }
                      if (year == now.year && month > now.month) {
                        return 'Tháng không hợp lệ';
                      }
                      if (year == now.year &&
                          month == now.month &&
                          day > now.day) {
                        return 'Ngày không hợp lệ';
                      }
                    }
                    return null; // Trả về null nếu giá trị hợp lệ
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.email), // Icon cho Tên
                      //,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 14.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return "Vui lòng nhập Email";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Vui lòng nhập email hợp lệ");
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: sdtController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  // Hiển thị bàn phím điện thoại
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    // Giới hạn tối đa 10 ký tự
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'SDT',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.call), // Icon cho Tên
                    ),
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('+84'),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 14.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // suffixIcon: IconButton(
                    //   onPressed: () async {
                    //     //Hiển thị danh bạ và chờ người dùng chọn liên hệ
                    //
                    //      if (contact != null && contact.phones!.isNotEmpty) {
                    //       // Lấy số điện thoại từ liên hệ đã chọn và gán vào TextFormField
                    //       sdtController.text = contact.phones!.first.value!;
                    //      }
                    //   },
                    //   icon: Icon(Icons.contact_phone),
                    // ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Số điện thoại không được để trống";
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Vui lòng nhập Số điện thoại hợp lệ";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: diachiController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Địa chỉ',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.map), // Icon cho Tên
                      //,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 14.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value!.length == 0) {
                  //     return "Email cannot be empty";
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Đặt hai nút ở hai phía
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(RouterName.diadiem);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          // Điều chỉnh padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24), // Góc bo tròn
                          ),
                        ),
                        child: Text('Hủy'), // Text nút hủy
                      ),
                    ),
                    SizedBox(width: 16), // Khoảng cách giữa hai nút
                    Expanded(
                      child: isLoading
                          ? Loading()
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String uid = await signUp();
                                  if (uid.isNotEmpty) {
                                    Reference imagefile = FirebaseStorage
                                        .instance
                                        .ref()
                                        .child("hinhuser")
                                        .child("/${uid.toString()}.jpg");

                                    if (_imageFile != null) {
                                      UploadTask task =
                                          imagefile.putFile(_imageFile!);
                                      TaskSnapshot snapshot = await task;

                                      var newUrl =
                                          await snapshot.ref.getDownloadURL();
                                      Firestore(uid, newUrl);

                                    } else {
                                      // Nếu không có hình ảnh được chọn, tải hình ảnh mặc định lên Firebase Storage
                                      UploadTask task = imagefile.putData(
                                          (await rootBundle.load(
                                                  'assets/default_profile.png'))
                                              .buffer
                                              .asUint8List());
                                      TaskSnapshot snapshot = await task;

                                      var newUrl =
                                          await snapshot.ref.getDownloadURL();
                                      Firestore(uid, newUrl);
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                // Điều chỉnh padding
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(24), // Góc bo tròn
                                ),
                              ),
                              child: Text('Lưu'), // Text nút lưu
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
