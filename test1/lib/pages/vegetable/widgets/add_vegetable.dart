import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/apps/router/routername.dart';
import '../../thongbao/loading.dart';
import '../../thongbao/thongbao.dart';

import 'package:fast_contacts/fast_contacts.dart';

class AddVegetable extends StatefulWidget {
  @override
  _AddVegetableState createState() => _AddVegetableState();
}

class _AddVegetableState extends State<AddVegetable> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isAs = false;

  final TextEditingController tenvegetableController = new TextEditingController();
  final TextEditingController xuatxuvegetableController = new TextEditingController();
  final TextEditingController sinhtruongController = new TextEditingController();
  final TextEditingController uudiemController = new TextEditingController();
  final TextEditingController nhuocdiemController = new TextEditingController();
  final TextEditingController dieukienController = new TextEditingController();

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
      FirebaseFirestore.instance.collection('vegetable');
  DateTime now = DateTime.now();

  void Firestore(vid, newUrl) async {
    setState(() {
      isLoading = true;
    });
    await storeref.doc(vid).set({
      'hinhvegetable': newUrl.toString(),
      'xuatxu': xuatxuvegetableController.text,
      'tenvegetable': tenvegetableController.text,
      'sinhtruong': sinhtruongController.text,
      'uudiem': uudiemController.text,
      'nhuocdiem': nhuocdiemController.text,
      'dieukien': dieukienController.text,
      'vid': vid,
    }).then((value) async {
      setState(() {
        isLoading = false;
      });
      ThongBao().toastMessage('thêm giống cây trồng thành công!');
      context.goNamed(RouterName.vegetable);

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
        title: const Text('Thêm giống cây trồng'),
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
                        : const Icon(Icons.add_a_photo, size: 50),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tenvegetableController,
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
                  controller: xuatxuvegetableController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'xuât xứ',
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
                SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: sinhtruongController,
                  // initialValue:,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Thời gian sinh trưởng ',
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
                      return 'Vui lòng nhập tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: uudiemController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Ưu điểm',
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
                      return 'Vui lòng nhập thông tin';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline, // Cho phép nhập nhiều dòng
                  maxLines: null, // Đặt maxLines là null để cho phép nhập nhiều dòng
                  minLines: 3, // Thiết lập số dòng tối thiểu (ở đây là 3 dòng)
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nhuocdiemController,
                  // Hiển thị bàn phím điện thoại
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Nhược điểm',
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
                      return 'Vui lòng nhập thông tin';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline, // Cho phép nhập nhiều dòng
                  maxLines: null, // Đặt maxLines là null để cho phép nhập nhiều dòng
                  minLines: 3, // Thiết lập số dòng tối thiểu (ở đây là 3 dòng)
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: dieukienController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Điều kiện sinh trưởng và phát triển',
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
                      return 'Vui lòng nhập thông tin';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline, // Cho phép nhập nhiều dòng
                  maxLines: null, // Đặt maxLines là null để cho phép nhập nhiều dòng
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
                          context.goNamed(RouterName.vegetable);
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
                                String formattedDate = "${now.hour}:${now.minute}:${now.second} ${now.day}-${now.month}-${now.year}";
                                String vid = formattedDate.toString();

                                if (_formKey.currentState!.validate()) {
                                  Reference imagefile = FirebaseStorage.instance
                                      .ref()
                                      .child("hinhvegetable")
                                      .child("/${tenvegetableController.text}.jpg");

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
                                                'assets/default_vegetable.png'))
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
