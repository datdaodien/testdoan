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
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          ThongBao().toastMessage('Đã xảy ra một số lỗi!');
        }

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            // print(snapshot.data!.docs[index]['name'].toString().toUpperCase());
            // print(widget.keySearch);
            // Lấy dữ liệu của từng item
            var name = snapshot.data!.docs[index]['name'].toString().toUpperCase();
            var sdt = snapshot.data!.docs[index]['sdt'].toString().toUpperCase();
            var diachi = snapshot.data!.docs[index]['diachi'].toString().toUpperCase();
            var searchKey = widget.keySearch.toUpperCase();

            // Kiểm tra nếu bất kỳ trường nào chứa giá trị tìm kiếm
            bool isNameContains = name.contains(searchKey);
            bool isSdtContains = sdt.contains(searchKey);
            bool isDiachiContains = diachi.contains(searchKey);

            if (isNameContains || isSdtContains || isDiachiContains) {
            return InkWell(
              onTap: () {
                context.goNamed(RouterName.detaildiadiem,
                    extra: snapshot.data!.docs[index].data());
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
                              SizedBox(height:20 ),
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
                                  snapshot.data!.docs[index]['diachi'],
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
                          SizedBox(height: 15),
                          InkWell(
                            child: IconButton(
                              iconSize: 30,
                              icon: Icon(Icons.phone),
                              onPressed: () {
                                final phoneNumber = snapshot.data!.docs[index]['sdt'].toString();
                                FlutterPhoneDirectCaller.callNumber('tel:$phoneNumber');
                              },
                            ),
                          ),
                          InkWell(
                            child: IconButton(
                              iconSize: 30,
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                final uid = snapshot.data!.docs[index]['uid'].toString();

                                UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
                                User? user = userCredential.user;

                                if (user != null && user.uid == uid) {
                                  await user.delete();
                                  print('Đã xóa tài khoản thành công!');
                                } else {
                                  print('Không tìm thấy người dùng hoặc UID không khớp!');
                                }

                                await Storageref.child("/$uid.jpg").delete();

                                await FirebaseFirestore.instance.collection('users').doc(uid).delete().then((value) {
                                  ThongBao().toastMessage('đã xóa người dùng!');
                                }).onError((error, stackTrace) {
                                  ThongBao().toastMessage('lỗi!');
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            } else {
            return const SizedBox(); // Trả về widget trống nếu không tìm thấy kết quả
            }
          },
        );
      },
    );
  }

}

