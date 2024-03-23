import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class DichBenhDetailPage2 extends StatelessWidget {
  final Map<String, dynamic> dichbenhData;

  DichBenhDetailPage2({required this.dichbenhData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết dịch bệnh'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('dichbenh')
                      .doc(dichbenhData['id'])
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('Dữ liệu không tồn tại'));
                    } else {
                      final item = snapshot.data!.data() as Map<String, dynamic>;
                      List<String> bieuhien = item['bieuhien'].toString().split(', ');
                      List<String> cachdieutri = item['cachdieutri'].toString().split(', ');
                      List<dynamic> thuongXuatHienList = item['thuongxuathien'];

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                                placeholder: kTransparentImage,
                                image:item['hinhdichbenh'],
                                fit: BoxFit.cover,
                                // Các thuộc tính khác của hình ảnh có thể được thêm vào đây
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tên dich bênh:',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '   ${item['tendichbenh']}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Thuộc loại:',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    ' + ${item['loaidichbenh']}',
                                    // Xuất xứ
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Thường xuất hiện ở các loại cây:',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: thuongXuatHienList.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, left: 8),
                                        child: Text('+ $item'),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Biểu hiện đặt tính:',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: bieuhien.map((condition) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, left: 8),
                                        child: Text('+ $condition.'),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'cách điều trị:',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: cachdieutri.map((condition) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, left: 8),
                                        child: Text('+ $condition.'),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'cách điều trị cho tình hình hiện tại:',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' + ${dichbenhData['description']}',
                                    // style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

