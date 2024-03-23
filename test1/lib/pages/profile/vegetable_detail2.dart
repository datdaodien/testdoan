import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class VegetableDetailPage2 extends StatelessWidget {
  final Map<String, dynamic> vegetableData;

  VegetableDetailPage2({required this.vegetableData});

  @override
  Widget build(BuildContext context) {
    final fireStore = FirebaseFirestore.instance
        .collection('vegetable')
        .doc(vegetableData['vid'])
        .snapshots();
    print(vegetableData['vid']);

    return StreamBuilder<DocumentSnapshot>(
        stream: fireStore,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Document does not exist'));
          }

          // Lấy dữ liệu từ tài liệu
          Map<String, dynamic> item =
              snapshot.data!.data() as Map<String, dynamic>;
          List<String> dieukien =
              (snapshot.data!.get('dieukien') as String).split(', ');
          List<String> uudiem =
              (snapshot.data!.get('uudiem') as String).split(', ');
          List<String> nhuocdiem =
              (snapshot.data!.get('nhuocdiem') as String).split(', ');
          // Tiếp tục xây dựng giao diện với dữ liệu lấy được
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverPersistentHeader(
                    delegate: MySliverPersistentHeaderDelegate(item: item),
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tên Giống cây trồng:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '   ${item['tenvegetable']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Xuất xứ:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ' + ${item['xuatxu']}',
                                  // Xuất xứ
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Thời gian sinh trưởng và phát triển:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ' + ${item['sinhtruong']}',
                                  // Sinh trưởng
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Điều kiện sinh trưởng và phát triển:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: dieukien.map((condition) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 8),
                                      child: Text('+ $condition.'),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Ưu điểm:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: uudiem.map((condition) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 8),
                                      child: Text('+ $condition.'),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Nhược điểm:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: nhuocdiem.map((condition) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 8),
                                      child: Text('+ $condition.'),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Map<String, dynamic> item;

  MySliverPersistentHeaderDelegate({required this.item});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      clipBehavior: Clip.hardEdge, // cat anh
      width: double.infinity, // tang rong theo chiuf ngang
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            // Điểm bắt đầu của đổ bóng (tọa độ X, Y)
            color: Colors.grey.shade200,
            // Màu của bóng đổ
            blurRadius: 2,
            // Bán kính làm mờ (độ mờ của bóng đổ)
            spreadRadius: 2, // Bán kính trải rộng của bóng đổ
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: FadeInImage.memoryNetwork(
        fit: BoxFit.cover,
        placeholder: kTransparentImage,
        image: item['hinhvegetable'] is String
            ? item['hinhvegetable']
            : '', // 'https://images.unsplash.com/photo-1490772888775-55fceea286b8?auto=format&fit=crop&q=80&w=1740&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      ),
    );
  }

  @override
  double get maxExtent => 200.0; // Kích thước tối đa của header khi cuộn lên

  @override
  double get minExtent =>
      100.0; // Kích thước tối thiểu của header khi cuộn xuống

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
