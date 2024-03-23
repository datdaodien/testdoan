import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/pages/dia_diem/detail_dia_diem/status.dart';
import 'package:test1/pages/dia_diem/detail_dia_diem/vegetable_detail.dart'; // Import Firestore

class DetailDiaDiemVegetable extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailDiaDiemVegetable({required this.item});

  @override
  State<DetailDiaDiemVegetable> createState() => _DetailDiaDiemVegetableState();
}

class _DetailDiaDiemVegetableState extends State<DetailDiaDiemVegetable> {
  void navigateToVegetableDetail(Map<String, dynamic> vegetableData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VegetableDetailPage(vegetableData: vegetableData),
      ),
    );
  }


  void addVegetableStatus(BuildContext context, Map<String, dynamic> data) {
    String description = ''; // Dùng để miêu tả trạng thái cây trồng
    File? _imageFile; // File ảnh đã chọn

    String time = DateTime.now().toString();

    Future<void> _getImage(ImageSource source) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }

    Future<String?> _uploadImageToStorage(Map<String, dynamic> data) async {
      if (_imageFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference = storage.ref().child('tinhtrang').child(
            '${data['tenvegetable']}').child('${time}.jpg');

        UploadTask uploadTask = storageReference.putFile(_imageFile!);
        await uploadTask.whenComplete(() => null);

        // Lấy đường dẫn của hình ảnh sau khi tải lên
        var imagePath = await storageReference.getDownloadURL();
        return imagePath;
      }
      return null;
    }
    showDialog(
      context: context,
      builder: (BuildContext context,) {
        return AlertDialog(
          title: const Text('Thêm tình trạng mới cho cây trồng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              const SizedBox(height: 20), // Khoảng cách giữa hình và TextFormField
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Miêu tả trạng thái cây trồng'),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog khi nhấn Hủy
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Sử dụng thời gian tạo để tạo tên cây trồng
                String? imagePath = await _uploadImageToStorage(data);


                // Thêm tình trạng mới của cây trồng vào Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.item['uid'])
                    .collection('vegetable')
                    .doc(data['vid'])
                    .collection(
                    'status') // Collection chứa các tình trạng của cây trồng
                    .doc(time) // Sử dụng thời gian tạo làm tên tài liệu
                    .set({
                  'description': description,
                  'imagePath': imagePath != null ? imagePath : '',
                  'ttid': time, // Lưu đường dẫn của ảnh nếu có
                });

                Navigator.pop(context); // Đóng dialog khi nhấn Lưu
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  void deleteVegetable(BuildContext context, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.item['uid'])
          .collection('vegetable')
          .doc(data['vid'])
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa cây trồng')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi xóa cây trồng')),
      );
      print('Error deleting vegetable: $e');
    }
  }

  void confirmDeleteVegetable(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa cây trồng ${data['tenvegetable']}'),
          content: Text('Bạn có chắc chắn muốn xóa cây trồng này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteVegetable(context, data); // Gọi hàm xóa
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách cây trồng ở địa điểm.'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.item['uid'])
            .collection('vegetable')
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Không có cây trồng nào'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: (){
                      navigateToVegetableDetail(data);
                  },
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.item['uid'])
                        .collection('vegetable')
                        .doc(data['vid'])
                        .collection('status')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> statusSnapshot) {
                      if (statusSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (statusSnapshot.hasError) {
                        return Text('Error: ${statusSnapshot.error}');
                      } else if (!statusSnapshot.hasData ||
                          statusSnapshot.data!.docs.isEmpty) {

                        return ListTile(
                          title: Text(data['tenvegetable']),
                          subtitle: const Text('Tình trạng chưa cập nhật'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text('Thêm tình trạng'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      addVegetableStatus(context, data);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text('Xóa'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      confirmDeleteVegetable(context, data);
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VegetableStatusPage(vegetableData: data,uid: widget.item['uid'],
                                        vid: data['vid'],),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text(data['tenvegetable']),
                          subtitle: const Text('Tình trạng đã cập nhật'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text('Thêm tình trạng'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      addVegetableStatus(context, data);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text('Xóa'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      confirmDeleteVegetable(context, data);
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VegetableStatusPage(vegetableData: data,uid: widget.item['uid'],
                                        vid: data['vid'],),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}