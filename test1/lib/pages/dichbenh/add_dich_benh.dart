import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/apps/router/routername.dart';
import '../thongbao/loading.dart';
import '../thongbao/thongbao.dart';

import 'package:fast_contacts/fast_contacts.dart';

class AddDichBenh extends StatefulWidget {
  @override
  _AddDichBenhState createState() => _AddDichBenhState();
}

class _AddDichBenhState extends State<AddDichBenh> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isAs = false;
  String selectedValue = '';

  final TextEditingController tendichbenhController =
      new TextEditingController();
  final TextEditingController loaidichbenhController =
      new TextEditingController();
  final TextEditingController thuongxuathienController =
      new TextEditingController();
  final TextEditingController bieuhienController = new TextEditingController();
  final TextEditingController cachdieutriController =
      new TextEditingController();

  final contacts = FastContacts.getAllContacts();
  File? _imageFile;
  ImagePicker picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  CollectionReference storeref =
      FirebaseFirestore.instance.collection('dichbenh');
  DateTime now = DateTime.now();

  void Firestore(dbid, newUrl) async {
    setState(() {
      isLoading = true;
    });
    await storeref.doc(dbid).set({
      'hinhdichbenh': newUrl.toString(),
      'loaidichbenh': loaidichbenhController.text,
      'tendichbenh': tendichbenhController.text,
      'thuongxuathien': thuongxuathienController.text,
      'bieuhien': bieuhienController.text,
      'cachdieutri': cachdieutriController.text,
      'dbid': dbid,
    }).then((value) async {
      setState(() {
        isLoading = false;
      });
      ThongBao().toastMessage('thêm giống cây trồng thành công!');
      context.goNamed(RouterName.dichbenh);

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
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Thêm giống dịch bệnh'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Chọn từ thư viện'),
                                  onTap: () {
                                    _getImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Chụp ảnh mới'),
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
                      width: 150, // Đặt kích thước hình vuông ở đây
                      height: 150, // Đặt kích thước hình vuông ở đây
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Đặt bo góc
                        border: Border.all(
                          color: Colors.white70,
                          width: 2.0,
                        ),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10), // Bo góc hình
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.add_a_photo, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tendichbenhController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Tên giống cây trồng',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.abc), // Icon cho Tên
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: loaidichbenhController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Chọn loại',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.abc),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 14.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (value) {
                        setState(() {
                          selectedValue = value;
                          loaidichbenhController.text =
                              value; // Gán giá trị vào TextFormField
                        });
                        // Do something with the selected value if needed
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Sâu hại',
                          child: Text('Sâu hại'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Dịch bệnh',
                          child: Text('Dịch bệnh'),
                        ),
                      ],
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    // Your onChanged logic here
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn loại';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: thuongxuathienController,
                  // initialValue:,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'các loại cây hay gặp bệnh này',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.text_snippet), // Icon cho Tên
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
                  onChanged: (value) {
                    if (value.isEmpty && isAs) {
                      // Nếu người dùng xóa
                      isAs = false; // Đặt cờ lại về false
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng các loại cây';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: bieuhienController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'biểu hiện bệnh',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.text_snippet), // Icon cho Tên
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
                  onChanged: (value) {
                    if (value.isEmpty && isAs) {
                      // Nếu người dùng xóa
                      isAs = false; // Đặt cờ lại về false
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thông tin biểu hiện của bệnh';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  // Cho phép nhập nhiều dòng
                  maxLines: null,
                  // Đặt maxLines là null để cho phép nhập nhiều dòng
                  minLines: 3, // Thiết lập số dòng tối thiểu (ở đây là 3 dòng)
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: cachdieutriController,
                  // Hiển thị bàn phím điện thoại
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Cách điều trị',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.text_snippet), // Icon cho Tên
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
                  onChanged: (value) {
                    if (value.isEmpty && isAs) {
                      // Nếu người dùng xóa
                      isAs = false; // Đặt cờ lại về false
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thông tin cách điều trị';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  // Cho phép nhập nhiều dòng
                  maxLines: null,
                  // Đặt maxLines là null để cho phép nhập nhiều dòng
                  minLines: 3, // Thiết lập số dòng tối thiểu (ở đây là 3 dòng)
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Đặt hai nút ở hai phía
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(RouterName.dichbenh);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          // Điều chỉnh padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24), // Góc bo tròn
                          ),
                        ),
                        child: const Text('Hủy'), // Text nút hủy
                      ),
                    ),
                    const SizedBox(width: 16), // Khoảng cách giữa hai nút
                    Expanded(
                      child: isLoading
                          ? Loading()
                          : ElevatedButton(
                              onPressed: () async {
                                String formattedDate =
                                    "${now.hour}:${now.minute}:${now.second} ${now.day}-${now.month}-${now.year}";
                                String vid = formattedDate.toString();

                                if (_formKey.currentState!.validate()) {
                                  Reference imagefile = FirebaseStorage.instance
                                      .ref()
                                      .child("hinhdichbenh")
                                      .child(
                                          "/${tendichbenhController.text}.jpg");

                                  if (_imageFile != null) {
                                    UploadTask task =
                                        imagefile.putFile(_imageFile!);
                                    TaskSnapshot snapshot = await task;

                                    var newUrl =
                                        await snapshot.ref.getDownloadURL();
                                    Firestore(vid, newUrl);
                                  } else {
                                    // Nếu không có hình ảnh được chọn, tải hình ảnh mặc định lên Firebase Storage
                                    UploadTask task = imagefile.putData(
                                        (await rootBundle.load(
                                                'assets/default_dichbenh.png'))
                                            .buffer
                                            .asUint8List());
                                    TaskSnapshot snapshot = await task;

                                    var newUrl =
                                        await snapshot.ref.getDownloadURL();
                                    Firestore(vid, newUrl);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                // Điều chỉnh padding
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(24), // Góc bo tròn
                                ),
                              ),
                              child: const Text('Lưu'), // Text nút lưu
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
