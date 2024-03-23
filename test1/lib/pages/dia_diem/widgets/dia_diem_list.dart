import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../apps/router/routername.dart';
import '../../thongbao/thongbao.dart';
class DiaDiemList extends StatefulWidget {
  final String keySearch;
   const DiaDiemList({super.key, required this.keySearch});

  @override
  State<DiaDiemList> createState() => _DiaDiemListState();
}

class _DiaDiemListState extends State<DiaDiemList> {
  final Storageref = FirebaseStorage.instance.ref().child("hinhuser");

  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference storeref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          ThongBao().toastMessage('Đã xảy ra một số lỗi!');
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            // print(snapshot.data!.docs[index]['name'].toString().toUpperCase());
            // print(widget.keySearch);
            // Lấy dữ liệu của từng item
            var name = snapshot.data!.docs[index]['name'].toString().toUpperCase();
            var sdt = snapshot.data!.docs[index]['sdt'].toString().toUpperCase();
            var diachi = snapshot.data!.docs[index]['diachi'].toString().toUpperCase();
            var rool = snapshot.data!.docs[index]['rool'].toString().toUpperCase();

            bool isRoolContains = rool.contains('USER'); // Kiểm tra vai trò là 'user'
            var searchKey = widget.keySearch.toUpperCase();
            // Kiểm tra nếu bất kỳ trường nào chứa giá trị tìm kiếm
            bool isNameContains = name.contains(searchKey);
            bool isSdtContains = sdt.contains(searchKey);
            bool isDiachiContains = diachi.contains(searchKey);
           // bool isRoolContains = rool.contains("user");
            if ((isNameContains || isSdtContains || isDiachiContains) && isRoolContains){

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    context.goNamed(RouterName.detaildiadiem,
                        extra: snapshot.data!.docs[index].data()??'');
                  },
                  child: AspectRatio(
                    aspectRatio: 5 / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,

                                child: ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    fit: BoxFit.cover,
                                    image: (snapshot.data!.docs[index]['hinh']),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height:20 ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!.docs[index]['name'].toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1, // Giới hạn số dòng là 1
                                      overflow: TextOverflow.ellipsis, // Hiển thị dấu '...' nếu nội dung quá dài
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      snapshot.data!.docs[index]['sdt'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1, // Giới hạn số dòng là 1
                                      overflow: TextOverflow.ellipsis, // Hiển thị dấu '...' nếu nội dung quá dài
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      snapshot.data!.docs[index]['diachi'].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1, // Giới hạn số dòng là 1
                                      overflow: TextOverflow.ellipsis, // Hiển thị dấu '...' nếu nội dung quá dài
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              const SizedBox(height: 15),
                              InkWell(
                                child: IconButton(
                                  iconSize: 30,
                                  icon: const Icon(Icons.phone),
                                  onPressed: () {
                                    final phoneNumber = snapshot.data!.docs[index]['sdt'].toString();
                                    FlutterPhoneDirectCaller.callNumber('tel:$phoneNumber');
                                  },
                                ),
                              ),
                              InkWell(
                                child: IconButton(
                                  iconSize: 30,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final uid = snapshot.data!.docs[index]['uid'].toString();
                                    // Kiểm tra người dùng hiện tại
                                    User? currentUser = FirebaseAuth.instance.currentUser;
                                      // Hiểnị hộp thoại xác nhận xóa
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Xác nhận xóa tài khoản'),
                                            content: Text('Bạn có chắc chắn muốn xóa tài khoản ${snapshot.data!.docs[index]['name'].toString().toUpperCase()} không?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Hủy'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  // Thực hiện xóa tài khoản và dữ liệu liên quan
                                                  await Storageref.child("/$uid.jpg").delete();

                                                  await FirebaseFirestore.instance.collection('users').doc(uid).delete();

                                                  ThongBao().toastMessage('Đã xóa người dùng!');
                                                  currentUser?.delete();
                                                  Navigator.of(context).pop(); // Đóng hộp thoại xác nhận
                                                },
                                                child: const Text('Xác nhận'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                  },
                                ),
                              ),
                            ],
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
      },
    );
  }

}

