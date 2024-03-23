import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../thongbao/connetinternet.dart';

class Profileadmin2 extends StatefulWidget {
  const Profileadmin2({super.key});

  @override
  State<Profileadmin2> createState() => _Profileadmin2State();
}

class _Profileadmin2State extends State<Profileadmin2> {
  Stream<DocumentSnapshot<Map<String, dynamic>>> _getUserDataStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc("GqRyx5r76kW2W0eboPUC56Ej5sG2")
        .snapshots();
  }

  int calculateAge(String birthDate) {
    List<String> dateParts = birthDate.split('/'); // Tách ngày, tháng, năm
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    DateTime today = DateTime.now();
    DateTime birthday =
        DateTime(year, month, day); // Tạo DateTime từ ngày/tháng/năm
    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }
  DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc("GqRyx5r76kW2W0eboPUC56Ej5sG2");
  String defaultPhoneNumber = "0837671568";
   @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Thông tin lien hệ'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () async {
                DocumentSnapshot snapshot = await userRef.get();
                  final phoneNumber = (snapshot.data() as Map<String, dynamic>?)?['sdt'] ?? defaultPhoneNumber;
                  FlutterPhoneDirectCaller.callNumber('tel:$phoneNumber');
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getUserDataStream(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(userData['hinh']),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                userData['name'].toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20, // Kích thước chữ
                  fontWeight: FontWeight.bold, // Độ đậm của chữ
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Thông tin chi tiết',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['name'] ?? 'chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {

                            },
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['email'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tuổi: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(calculateAge(userData['tuoi']).toString())
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số Điện Thoại: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['sdt'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Địa Chỉ: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['diachi'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bằng Cấp: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {

                            },
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['bangcap'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên công ty: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['namecongty'] ?? 'Chưa cập nhật')
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
