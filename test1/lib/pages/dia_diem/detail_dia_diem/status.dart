
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_status.dart';
import 'dich_benh_detail.dart';

class VegetableStatusPage extends StatefulWidget {
  final Map<String, dynamic> vegetableData;
  final String uid;
  final String vid;

  VegetableStatusPage({
    required this.vegetableData,
    required this.uid,
    required this.vid,
  });

  @override
  _VegetableStatusPageState createState() => _VegetableStatusPageState();
}

class _VegetableStatusPageState extends State<VegetableStatusPage> {
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

                              // Lọc dữ liệu theo điều kiện được chọn
                              if (_selectedCondition == 'Hôm nay') {
                                return statusDate.year == today.year &&
                                    statusDate.month == today.month &&
                                    statusDate.day == today.day;
                              } else if (_selectedCondition == 'Hôm qua') {
                                final yesterday = today.subtract(const Duration(days: 1));
                                return statusDate.year == yesterday.year &&
                                    statusDate.month == yesterday.month &&
                                    statusDate.day == yesterday.day;
                              } else if (_selectedCondition == '2 ngày trước') {
                                final yesterday = today.subtract(const Duration(days: 2));
                                return statusDate.year == yesterday.year &&
                                    statusDate.month == yesterday.month &&
                                    statusDate.day == yesterday.day;
                              } else if (_selectedCondition == 'Tuần này') {
                                DateTime startOfWeek =
                                today.subtract(Duration(days: today.weekday - 1));
                                DateTime endOfWeek = today.add(Duration(days: 7 - today.weekday));
                                return statusDate.isAfter(startOfWeek) &&
                                    statusDate.isBefore(endOfWeek);
                              } else if (_selectedCondition == 'Tháng này') {
                                return statusDate.year == today.year &&
                                    statusDate.month == today.month;
                              }

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
                                                  DetailStatusPage(
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
                                                builder: (context) => DichBenhDetailPage(dichbenhData: dichbenh),
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
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        addVegetabledichbenh(context);
                      },
                      child: const Icon(Icons.add),
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

  void addVegetabledichbenh(BuildContext context) {
    String description = ''; // Dùng để miêu tả trạng thái cây trồng
    String selectedDisease = ''; // Biến để lưu loại dịch bệnh đã chọn
    String selectedDbid = ''; // Biến để lưu dbid đã chọn

    String time = DateTime.now().toString();


    showDialog(
      context: context,
      builder: (BuildContext context,) {
        return AlertDialog(
          title: const Text('Thêm dịch bệnh.'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('dichbenh').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No data available');
                    } else {
                      List<DropdownMenuItem<Map<String, dynamic>>> dropdownItems = [];
                      snapshot.data!.docs.forEach((doc) {
                        String diseaseName = doc['tendichbenh']; // Thay 'tenDichBenh' bằng key tương ứng trong Firestore
                        String dbid = doc['dbid']; // Lấy giá trị dbid từ Firestore

                        dropdownItems.add(DropdownMenuItem(
                          child: Text(diseaseName),
                          value: {
                            'tendichbenh': diseaseName,
                            'dbid': dbid,
                          },
                        ));
                      });

                      return DropdownButtonFormField<Map<String, dynamic>>(
                        decoration: const InputDecoration(
                          labelText: 'Loại Dịch bệnh',
                        ),
                        items: dropdownItems,
                        onChanged: (Map<String, dynamic>? selectedValue) {
                          // Thực hiện hành động khi giá trị được chọn
                          if (selectedValue != null) {
                            setState(() {
                              selectedDisease = selectedValue['tendichbenh'];
                              selectedDbid = selectedValue['dbid'];
                            });
                          }
                        },
                      );
                    }
                  },
                ),

                const SizedBox(height: 20), // Khoảng cách giữa hình và TextFormField
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Cách chữa trị cho tình hình hiện tại'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog khi nhấn Hủy
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Sử dụng thời gian tạo để tạo tên cây trồng

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .collection('vegetable')
                    .doc(widget.vid)
                    .collection(
                    'dichbenh') // Collection chứa các tình trạng của cây trồng
                    .doc(time) // Sử dụng thời gian tạo làm tên tài liệu
                    .set({
                  'description': description,
                  'tendichbenh':selectedDisease,
                  'id':selectedDbid,
                  'dbid': time, // Lưu đường dẫn của ảnh nếu có
                });

                Navigator.pop(context); // Đóng dialog khi nhấn Lưu
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
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
      Duration difference = now.difference(statusDate).abs();
      return '${difference.inDays} ngày trước';
    }
  }
}
