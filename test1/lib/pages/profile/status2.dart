import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detail_status2.dart';
import 'dich_benh_detail2.dart';

class VegetableStatusPage2 extends StatefulWidget {
  final Map<String, dynamic> vegetableData;
  final String uid;
  final String vid;

  VegetableStatusPage2({
    required this.vegetableData,
    required this.uid,
    required this.vid,
  });

  @override
  _VegetableStatusPage2State createState() => _VegetableStatusPage2State();
}

class _VegetableStatusPage2State extends State<VegetableStatusPage2> {
  String _selectedCondition = 'Tất cả'; // Mặc định hiển thị tất cả
  @override
  void initState() {
    super.initState();
    _selectedCondition = 'Tất cả';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tình trạng ${widget.vegetableData['tenvegetable']}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedCondition = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Tất cả',
                  child: Text('Tất cả'),
                ),
                const PopupMenuItem(
                  value: 'Hôm nay',
                  child: Text('Hôm nay'),
                ),
                const PopupMenuItem(
                  value: 'Hôm qua',
                  child: Text('Hôm qua'),
                ),
                const PopupMenuItem(
                  value: '2 ngày trước',
                  child: Text('2 ngày trước'),
                ),
                const PopupMenuItem(
                  value: 'Tuần này',
                  child: Text('Tuần này'),
                ),
                const PopupMenuItem(
                    value: 'Tháng này',
                    child: Text('Tháng này'),
                ),
                // Thêm các tùy chọn khác cho tuần này, tháng này,...
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      color: Colors.grey[200],
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.uid)
                            .collection('vegetable')
                            .doc(widget.vid)
                            .collection('status')
                            .orderBy('ttid',
                            descending: true) // Sắp xếp theo ngày giảm dần
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          print(widget.vegetableData['vid']);
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Text(
                                    'Không có tình trạng cho cây trồng: ${widget.vegetableData['tenvegetable']}'));
                          } else {
                            // Lọc dữ liệu theo điều kiện được chọn
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            statusDocs = (snapshot.data!.docs as List<
                                QueryDocumentSnapshot<
                                    Map<String, dynamic>>>)
                                .where((status) {
                              final DateTime statusDate =
                              DateTime.parse(status['ttid']);
                              final DateTime today = DateTime.now();
                              if (_selectedCondition == 'Hôm nay') {
                                return statusDate.year == today.year &&
                                    statusDate.month == today.month &&
                                    statusDate.day == today.day;
                              } else if (_selectedCondition == 'Hôm qua') {
                                final yesterday =
                                today.subtract(const Duration(days: 1));
                                return statusDate.year == yesterday.year &&
                                    statusDate.month == yesterday.month &&
                                    statusDate.day == yesterday.day;
                              } else if (_selectedCondition == '2 ngày trước') {
                                final yesterday =
                                today.subtract(const Duration(days: 2));
                                return statusDate.year == yesterday.year &&
                                    statusDate.month == yesterday.month &&
                                    statusDate.day == yesterday.day;
                              }else if (_selectedCondition == 'Tuần này') {
                                DateTime startOfWeek =
                                today.subtract(Duration(days: today.weekday - 1));
                                DateTime endOfWeek = today.add(Duration(days: 7 - today.weekday));
                                return statusDate.isAfter(startOfWeek) &&
                                    statusDate.isBefore(endOfWeek);
                              } else if (_selectedCondition == 'Tháng này') {
                                return statusDate.year == today.year &&
                                    statusDate.month == today.month;
                              }
                              // Thêm các điều kiện cho tuần này, tháng này,...
                              return true;
                            }).toList();

                            // Hiển thị danh sách tình trạng
                            return ListView.builder(
                              itemCount: statusDocs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> status =
                                statusDocs[index].data();
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // Điều chỉnh bán kính để bo tròn góc
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailStatusPage2(
                                                      status: status)));

                                    },
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      subtitle: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: status['imagePath'] != null
                                                ? Image.network(
                                              status['imagePath'],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                                : Container(), // Thay thế bằng hình ảnh mặc định nếu không có
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Mô tả tình trạng: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                Text(
                                                  "  + ${status['description']}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold),
                                                  maxLines: 3,
                                                ),
                                                Text(
                                                  formatDate(status['ttid']
                                                      .toString()),
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(height: 8),
                                                // Thêm các thông tin khác nếu cần
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.uid)
                                  .collection('vegetable')
                                  .doc(widget.vid)
                                  .collection('dichbenh')
                                  .orderBy('dbid',
                                  descending:
                                  true) // Sắp xếp theo ngày giảm dần
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                print(widget.vegetableData['vid']);
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Text(
                                          'Không có dịch bệnh trên: ${widget.vegetableData['tenvegetable']}'));
                                } else {
                                  // Lọc dữ liệu theo điều kiện được chọn
                                  List<
                                      QueryDocumentSnapshot<
                                          Map<String, dynamic>>>
                                  dichbenhDocs = (snapshot.data!.docs as List<
                                      QueryDocumentSnapshot<
                                          Map<String, dynamic>>>)
                                      .where((dichbenh) {
                                    final DateTime dichbenhDate =
                                    DateTime.parse(dichbenh['dbid']);
                                    final DateTime today = DateTime.now();
                                    if (_selectedCondition == 'Hôm nay') {
                                      return dichbenhDate.year == today.year &&
                                          dichbenhDate.month == today.month &&
                                          dichbenhDate.day == today.day;
                                    } else if (_selectedCondition ==
                                        'Hôm qua') {
                                      final yesterday =
                                      today.subtract(const Duration(days: 1));
                                      return dichbenhDate.year ==
                                          yesterday.year &&
                                          dichbenhDate.month == yesterday.month &&
                                          dichbenhDate.day == yesterday.day;
                                    } else if (_selectedCondition ==
                                        '2 ngày trước') {
                                      final yesterday =
                                      today.subtract(const Duration(days: 2));
                                      return dichbenhDate.year ==
                                          yesterday.year &&
                                          dichbenhDate.month == yesterday.month &&
                                          dichbenhDate.day == yesterday.day;
                                    }
                                    // Thêm các điều kiện cho tuần này, tháng này,...
                                    return true;
                                  }).toList();

                                  // Hiển thị danh sách tình trạng
                                  return ListView.builder(
                                    itemCount: dichbenhDocs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> dichbenh =
                                      dichbenhDocs[index].data();
                                      return Card(
                                        elevation: 3,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Điều chỉnh bán kính để bo tròn góc
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DichBenhDetailPage2(dichbenhData: dichbenh),
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8),
                                            subtitle: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        'Tên dịch bênh đang bị: ${dichbenh['tendichbenh']}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      const Text(
                                                        'Cách chửa trị dịch bệnh: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        "  + ${dichbenh['description']}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                        maxLines: 3,
                                                      ),
                                                      Text(
                                                        formatDate(
                                                            dichbenh['dbid']
                                                                .toString()),
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Thêm các thông tin khác nếu cần
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  String formatDate(String dateString) {
    DateTime statusDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    if (statusDate.year == now.year &&
        statusDate.month == now.month &&
        statusDate.day == now.day) {
      return 'Hôm nay';
    } else if (statusDate.add(const Duration(days: 1)).year == now.year &&
        statusDate.add(const Duration(days: 1)).month == now.month &&
        statusDate.add(const Duration(days: 1)).day == now.day) {
      return 'Hôm qua';
    } else {
      Duration difference = now.difference  (statusDate).abs();
      return '${difference.inDays} ngày trước';
    }
  }
}
