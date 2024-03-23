import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../api/uid.dart';
import '../../../apps/router/routername.dart';
import '../../thongbao/thongbao.dart';


class VegetableList extends StatefulWidget {
  final String keySearch;
   VegetableList({super.key, required this.keySearch});

  @override
  State<VegetableList> createState() => _VegetableListState();
}

class _VegetableListState extends State<VegetableList> {
  final Storageref = FirebaseStorage.instance.ref().child("hinhvegetable");

  final fireStore = FirebaseFirestore.instance.collection('vegetable').orderBy('vid', descending: false).snapshots();

   File? _imageFile;
   bool isLoading = false;
   ImagePicker picker = ImagePicker();

   Future<void> _getImage(ImageSource source) async {
     final pickedFile = await picker.pickImage(source: source);
     if (pickedFile != null) {
       setState(() {
         _imageFile = File(pickedFile.path);
       });
     }
   }
  String userRole = UserRole().role;


  @override
  Widget build(BuildContext context) {
    ModalRoute<Object?>? route = ModalRoute.of(context);//kiểm tra luồn di chuyển.
    bool isAdmin = userRole == 'admin';
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          ThongBao().toastMessage('Đã xảy ra một số lỗi!');
        }
        print(snapshot.data!.docs.length);
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,

          itemBuilder: (BuildContext context, int index) {
            var name = snapshot.data!.docs[index]['tenvegetable'].toString().toUpperCase();
            var origin = snapshot.data!.docs[index]['xuatxu'].toString().toUpperCase();
            var conditions = snapshot.data!.docs[index]['dieukien'].toString().toUpperCase();
            var searchKey = widget.keySearch.toUpperCase();
            print(widget.keySearch);
              // Kiểm tra nếu bất kỳ trường nào chứa giá trị tìm kiếm
            bool isNameContains = name.contains(searchKey);
            bool isoriginContains = origin.contains(searchKey);
            bool isconditionsContains = conditions.contains(searchKey);
            // bool isRoolContains = rool.contains("user");
            if (isNameContains || isoriginContains || isconditionsContains){

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    if (route?.settings.name == RouterName.vegetable2) {
                      context.goNamed(RouterName.detailvegetable2, extra: snapshot.data!.docs[index].data());
                    } else {
                      context.goNamed(RouterName.detailvegetable, extra: snapshot.data!.docs[index].data());
                    }
                  },
                  onLongPress:isAdmin? () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Cập nhật'),
                              onTap: () {
                                Navigator.pop(context);
                                _showMyDialog(context,snapshot.data!.docs[index]);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Xóa'),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Xác nhận xóa'),
                                      content: Text('Bạn có chắc chắn muốn xóa ${snapshot.data!.docs[index]['tenvegetable']} này không?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Hủy'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await Storageref.child("/${snapshot.data!.docs[index]['tenvegetable']}.jpg").delete();

                                            await snapshot.data!.docs[index].reference.delete().then((value) {
                                              ThongBao().toastMessage('Đã xóa thành công!');
                                            }).onError((error, stackTrace) {
                                              ThongBao().toastMessage('Đã xảy ra lỗi!');
                                            });
                                            Navigator.of(context).pop(); // Đóng dialog sau khi xóa
                                          },
                                          child: const Text('Xóa'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }:null,
                  child: AspectRatio(
                  aspectRatio: 5/2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    fit: BoxFit.cover,
                                    image:(snapshot.data!.docs[index]['hinhvegetable']),

                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data!.docs[index]['tenvegetable'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black, // Màu văn bản
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text('Xuất xứ: '),
                                    Text(
                                      snapshot.data!.docs[index]['xuatxu'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Điều kiện phát triền: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.5), // Màu chữ của văn bản con với độ mờ
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '+ ' + snapshot.data!.docs[index]['dieukien'],

                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1, // Giới hạn số dòng là 1
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
            } else {
              return const SizedBox(height: 10); // Trả về widget trống nếu không tìm thấy kết quả
            }
          },
        );
      }

    );
  }

   Future<void> _showMyDialog(BuildContext context,DocumentSnapshot data) async {
     TextEditingController nameController = TextEditingController(text: data['tenvegetable']);
     TextEditingController xuatxuController = TextEditingController(text: data['xuatxu']);
     TextEditingController sinhtruongController = TextEditingController(text: data['sinhtruong']);
     TextEditingController uudiemController = TextEditingController(text: data['uudiem']);
     TextEditingController nhuocdiemController = TextEditingController(text: data['nhuocdiem']);
     TextEditingController dieukienController = TextEditingController(text: data['dieukien']);

     await showDialog(
       context: context,
       builder: (BuildContext context) {
         return StatefulBuilder(
           builder: (BuildContext context, StateSetter setState) {
             return AlertDialog(
               title: const Text('Cập Nhật Thông Tin'),
               content: SingleChildScrollView(
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     GestureDetector(
                       onTap: () async {
                         await showModalBottomSheet(
                           context: context,
                           builder: (BuildContext context) {
                             return SafeArea(
                               child: Column(
                                 mainAxisSize: MainAxisSize.min,
                                 children: <Widget>[
                                   ListTile(
                                     leading: const Icon(Icons.photo_library),
                                     title: const Text('Chọn từ thư viện'),
                                     onTap: () async {
                                       await _getImage(ImageSource.gallery);
                                       Navigator.pop(context);
                                       setState(() {}); // Cập nhật giao diện sau khi chọn ảnh
                                     },
                                   ),
                                   ListTile(
                                     leading: const Icon(Icons.photo_camera),
                                     title: const Text('Chụp ảnh mới'),
                                     onTap: () async {
                                       await _getImage(ImageSource.camera);
                                       Navigator.pop(context);
                                       setState(() {}); // Cập nhật giao diện sau khi chụp ảnh
                                     },
                                   ),
                                 ],
                               ),
                             );
                           },
                         );
                       },
                       child: Stack(
                         children: [
                           Container(
                             width: 150,
                             height: 150,
                             decoration: BoxDecoration(
                               border: Border.all(
                                 color: Colors.white70,
                                 width: 2.0,
                               ),
                             ),
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(10),
                               child: _imageFile != null
                                   ? Image.file(
                                 _imageFile!,
                                 fit: BoxFit.cover,
                                 width: 200,
                                 height: 200,
                               )
                                   : FadeInImage.memoryNetwork(
                                 placeholder: kTransparentImage,
                                 image: data['hinhvegetable'],
                                 fit: BoxFit.cover,
                                 width: 200,
                                 height: 200,
                               ),
                             ),
                           ),
                           Positioned(
                             bottom: 0,
                             right: 0,
                             child: Container(
                               padding: const EdgeInsets.all(4),
                               decoration: const BoxDecoration(
                                 color: Colors.white,
                                 shape: BoxShape.circle,
                               ),
                               child: const Icon(Icons.camera_alt),
                             ),
                           ),
                         ],
                       ),
                     ),
                     TextField(
                       controller: nameController,
                       decoration: const InputDecoration(labelText: 'Tên'),
                     ),
                     TextField(
                       controller: xuatxuController,
                       decoration: const InputDecoration(labelText: 'Xuất xứ'),
                     ),
                     TextField(
                       controller: sinhtruongController,
                       decoration: const InputDecoration(labelText: 'Thời gian sinh trưởng'),
                     ),
                     TextField(
                       controller: uudiemController,
                       decoration: const InputDecoration(labelText: 'Ưu điểm'),
                     ),
                     TextField(
                       controller: nhuocdiemController,
                       decoration: const InputDecoration(labelText: 'Nhược điểm'),
                     ),
                     TextField(
                       controller: dieukienController,
                       decoration: const InputDecoration(labelText: 'Điều kiện sinh trưởng'),
                     ),
                   ],
                 ),
               ),
               actions: [
                 TextButton(
                   onPressed: () {
                     Navigator.of(context).pop();
                   },
                   child: const Text('Hủy'),
                 ),
                 ElevatedButton(
                   onPressed: isLoading
                       ? null
                       :() async {
                     setState(() {
                       isLoading = true;
                     });
                     if (_imageFile != null) {
                       // Lưu hình ảnh mới lên Firebase Storage và lấy URL
                       UploadTask uploadTask = Storageref.child("/${nameController.text}.jpg").putFile(_imageFile!);
                       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
                       var imageUrl = await taskSnapshot.ref.getDownloadURL();

                       // Cập nhật URL mới vào Firestore
                       await FirebaseFirestore.instance.collection('vegetable').doc(data.id).set({
                         'hinhvegetable': imageUrl,
                       });
                     }

                     // Cập nhật các trường thông tin khác vào Firestore
                     await FirebaseFirestore.instance.collection('vegetable').doc(data.id).update({
                       'vid': data['vid'],
                       'tenvegetable': nameController.text,
                       'xuatxu': xuatxuController.text,
                       'sinhtruong': sinhtruongController.text,
                       'uudiem': uudiemController.text,
                       'nhuocdiem': nhuocdiemController.text,
                       'dieukien': dieukienController.text,
                     });
                     setState(() {
                       isLoading = false;
                     });
                     ThongBao().toastMessage('Đã cập nhật cây trồng!');
                     // Đóng dialog sau khi cập nhật xong
                     Navigator.of(context).pop();
                   },
                   child: isLoading ? const CircularProgressIndicator() : const Text('Lưu'),
                 ),
               ],
             );
           },
         );
       },
     );
   }
}
