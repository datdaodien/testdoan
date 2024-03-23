import 'package:flutter/material.dart';

class DetailStatusPage2 extends StatelessWidget {
  final Map<String, dynamic> status;

  const DetailStatusPage2({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết tình trạng'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            status['imagePath'] != null
                ? Image.network(
              status['imagePath'],
              width: double.infinity,
              // height: 200,
              fit: BoxFit.cover,
            )
                : Container(), // Nếu không có hình ảnh, hiển thị một container trống
            SizedBox(height: 20),
            Text(
              'Mô tả tình trạng:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              status['description'],
              style: TextStyle(fontSize: 16),
            ),
            // Các thông tin khác nếu cần
          ],
        ),
      ),
    );
  }
}
