import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:test1/pages/thongke/bar_chart_sample7.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ThongKePage extends StatefulWidget {
  const ThongKePage({super.key});

  @override
  State<ThongKePage> createState() => _ThongKePageState();
}

class _ThongKePageState extends State<ThongKePage> {
  List<BarData> allUserData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  void setup() async {
    allUserData = await getAllUserData();
  }

  Color generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
    );
  }

  Future<List<BarData>> getAllUserData() async {
    List<BarData> allUserData = [];

    try {
      QuerySnapshot userSnapshots =
          await FirebaseFirestore.instance.collection('users').get();

      for (QueryDocumentSnapshot userDoc in userSnapshots.docs) {
        // Lấy UID của mỗi user
        String uid = userDoc.id;
        Map<String, dynamic> userInformation =
            userDoc.data() as Map<String, dynamic>;

        String hinh = userInformation['hinh'] ?? '';
        String diachi = userInformation['diachi'] ?? '';

        // Lấy dữ liệu từ collection 'vegetable' của mỗi user
        QuerySnapshot vegetableSnapshot =
            await userDoc.reference.collection('vegetable').get();
        int numberOfVegetables = vegetableSnapshot.docs.length;
        List<Map<String, dynamic>> userData = [];
        for (QueryDocumentSnapshot vegetableDoc in vegetableSnapshot.docs) {
          String vegetableId = vegetableDoc.id;
          Map<String, dynamic> vegetableData =
              vegetableDoc.data() as Map<String, dynamic>;

          // Lấy số lượng dịch bệnh của loại cây trồng này
          QuerySnapshot diseaseSnapshot =
              await vegetableDoc.reference.collection('dichbenh').get();
          int numberOfDiseases = diseaseSnapshot.docs.length;

          // Thêm thông tin của loại cây trồng và số lượng dịch bệnh vào danh sách userData
          Map<String, dynamic> vegetableInfo = {
            'vegetableId': vegetableId,
            'vegetableData': vegetableData,
            'numberOfDiseases': numberOfDiseases,
          };
          userData.add(vegetableInfo);

          // Cộng dồn số lượng dịch bệnh vào biến tổng
        }

        // Tạo một Map chứa thông tin của mỗi user về các loại cây trồng và số lượng dịch bệnh
        // Map<String, dynamic> userInfo = {
        //   'uid': uid,
        //   'hinh': hinh,
        //   'diachi': diachi,
        //   "numberOfVegetables": numberOfVegetables,
        //   'totalNumberOfDiseases': totalNumberOfDiseases,
        //   'userData': userData,
        // };

        BarData item = BarData(generateRandomColor(),
            numberOfVegetables.toDouble(), 0, hinh, diachi, uid);

        // Thêm thông tin của mỗi user vào danh sách allUserData
        allUserData.add(item);
      }
    } catch (e) {
      print('Error fetching all user data: $e');
    }

    return allUserData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 400,
          child: BarChartSample7(data: allUserData, isShowImage: true)),
    );
  }
}
