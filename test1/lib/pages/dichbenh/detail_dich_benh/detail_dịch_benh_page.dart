import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class DetailDichBenhPage extends StatelessWidget {
  final Map<String, dynamic> item;

  DetailDichBenhPage({super.key, required this.item});



  @override
  Widget build(BuildContext context) {


    List<String> bieuhien = item['bieuhien'].toString().split(', ');
    List<String> cachdieutri = item['cachdieutri'].toString().split(', ');
    List<dynamic> thuongXuatHienList = item['thuongxuathien'];
    print(item['thuongxuathien']);
    return Scaffold(
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
                              padding: const EdgeInsets.only(bottom: 5, left: 8),
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
                              padding: const EdgeInsets.only(bottom: 5,left: 8),
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
                              padding: const EdgeInsets.only(bottom: 5,left: 8),
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
    );
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
        image: item['hinhdichbenh'], // 'https://images.unsplash.com/photo-1490772888775-55fceea286b8?auto=format&fit=crop&q=80&w=1740&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
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

