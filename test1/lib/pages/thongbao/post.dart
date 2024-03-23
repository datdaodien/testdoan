import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:test1/pages/thongbao/thongbao.dart';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final _searchFilter = TextEditingController();
  final _editFilter = TextEditingController();
  final postController = TextEditingController();
  bool loading = false;

  final databaseRef = FirebaseDatabase.instance.ref('notifications');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, //nút back mở
        centerTitle: true, //căn giữ tiêu đề
        title: const Text("Tạo Thông Báo"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _searchFilter,
                onChanged: (String? value) {
                  // setState(() {});
                  setState(() {});
                },
                decoration: const InputDecoration(
                    hintText: 'tìm kiếm', border: OutlineInputBorder()),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(
                  child: CircularProgressIndicator(),
                ),
                query: databaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (_searchFilter.text.isEmpty) {
                    // Xử lý dữ liệu từ snapshot và hiển thị
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('body').value.toString()),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                // PopupMenuItem(
                                //     value: 1,
                                //     child: ListTile(
                                //       onTap: (() {
                                //         Navigator.pop(context);
                                //         _showMyDialog(
                                //             title,
                                //             snapshot.child('con')
                                //                 .child('id')
                                //                 .value
                                //                 .toString());
                                //       }),
                                //       leading: Icon(Icons.edit),
                                //       title: Text('Cập nhật'),
                                //     )),
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        String? notificationId = snapshot.key;
                                        databaseRef
                                            .child(notificationId!)
                                            .remove()
                                            .then((value) {
                                          ThongBao().toastMessage(
                                              'Đã xóa thành công!');
                                        }).onError((error, stackTrace) {
                                          ThongBao()
                                              .toastMessage('Đã xảy ra lỗi!');
                                        });
                                      },
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Xóa'),
                                    )),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(_searchFilter.text.toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('body').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<void> _showMyDialog(String title, String id) async {
    _editFilter.text = title;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Người dùng phải nhấn vào nút!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cập nhật'),
          content: Container(
            child: TextFormField(
              controller: _editFilter,
              decoration: const InputDecoration(
                hintText: 'Update your message',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cập nhật'),
              onPressed: () {
                Navigator.of(context).pop();
                databaseRef
                    .child(id)
                    .child('con')
//dùng up data để ập nhật
                    .update({'tite': _editFilter.text}).then((value) {
                  ThongBao().toastMessage('Cập nhật thành công!');
                }).onError((error, stackTrace) {
                  ThongBao().toastMessage('Đã xảy ra lỗi!');
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('notifications');

  String? _selectedContent;

  // Biến để lưu trữ nội dung được chọn từ Dropdown
  List<String> predefinedContents = [
    'Thông Báo Sự Kiện',
    'Cảnh Báo Bịch Bệnh',
    'Thông Báo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi thông báo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: const OutlineInputBorder(),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  itemBuilder: (BuildContext context) {
                    return predefinedContents.map((String content) {
                      return PopupMenuItem<String>(
                        value: content,
                        child: Text(content),
                      );
                    }).toList();
                  },
                  onSelected: (String? value) {
                    setState(() {
                      _titleController.text =
                          value ?? ''; // Gán giá trị vào TextFormField
                    });
                  },
                ),
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                // Your onChanged logic here
              },
              validator: (value) {
                if (_selectedContent == null) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn loại hoặc nhập liệu';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _bodyController,
              minLines: 6,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
                hintText: 'Nhập nội dung',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
                  // Hiển thị cảnh báo nếu Title hoặc Body chưa được nhập
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Lỗi'),
                        content: const Text('Vui lòng nhập đầy đủ Title và Body.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Nếu đã nhập đầy đủ dữ liệu, hiển thị hộp thoại xác nhận
                  _showConfirmationDialog(context);
                }
              },
              child: const Text('Gửi thông báo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn gửi thông báo này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Gửi'),
              onPressed: () async {
                List<String> allTokens = await getAllTokens();
                if (allTokens.isNotEmpty) {
                  await sendPushMessages(allTokens);
                  ThongBao().toastMessage("Thông báo đã được gửi");
                  print('Đã gửi thông báo đến tất cả các thiết bị.');
                } else {
                  print('Không có mã thông báo nào có sẵn để gửi thông báo.');
                }
                _sendNotification();
                _titleController.clear();
                _bodyController.clear();
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }



  Future<List<String>> getAllTokens() async {
    DatabaseReference tokensRef =
        FirebaseDatabase.instance.ref('device_tokens');
    List<String> allTokens = [];

    try {
      DatabaseEvent event =
          await tokensRef.once(); // Sử dụng Event thay vì DataSnapshot
      Map<dynamic, dynamic>? tokensData =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (tokensData != null) {
        tokensData.forEach((key, value) {
          if (value['token'] != null) {
            allTokens.add(value['token']);
          }
        });
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách token: $e');
    }
    return allTokens;
  }

  Future<void> sendPushMessages(List<String> allTokens) async {
    if (allTokens.isEmpty) {
      print('Không có token nào để gửi thông báo.');
      return;
    }
    for (String token in allTokens) {
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAZ7vh0zo:APA91bGmCzDCTR2rBGKIFETTRe5ep11AJJPwVUT_qZPX8Un0cd-XbZUsMq2yGVTlYT8vqVo1TfTNakTbHXLgX79mtSYfGm_lGhWdIeJx67T-2dUxZyR8t9a5iep96sUw0iarx8uBoFsQ',
            // Thay thế bằng khóa máy chủ của bạn
          },
          body: constructFCMPayload(token),
        );
        print('Yêu cầu FCM cho thiết bị được gửi!');
      } catch (e) {
        print(e);
      }
    }
  }

  int _messageCount = 0;

  // Xây dựng tải trọng FCM cho mục đích trình diễn.
  String constructFCMPayload(String token) {
    _messageCount++;
    String title = _titleController.text;
    String body = _bodyController.text;
    return jsonEncode({
      'to': token,
      'data': {
        'via': 'FlutterFire Nhắn tin trên đám mây!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': title,
        'body': body,
      },
    });
  }

  void _sendNotification() {
    String title = _titleController.text;
    String body = _bodyController.text;

    // Lưu dữ liệu vào Realtime Database
    _database.push().set({
      'title': title,
      'body': body,
      'scheduletime': DateTime.now().toString(),
      'timestamp': DateTime.now().toString(),
    });
  }

}
// Future<void> _scheduleshowConfirmationDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Xác nhận'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Bạn có chắc chắn muốn gửi thông báo này không?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Hủy'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Gửi'),
//               onPressed: () async {
//                 String selectedDateTime = _dtimeController.text;
//                 List<String> allTokens = await getAllTokens();
//                 if (selectedDateTime.isNotEmpty) {
//                   // Schedule the notification
//                   await scheduleNotification(selectedDateTime);
//
//                   Navigator.of(context).pop();
//                   _titleController.clear();
//                   _bodyController.clear();
//                   _dtimeController.clear();
//                 } else {
//                   // Handle when the user hasn't selected date and time
//                 }
//
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
// Future<void> scheduleNotification(String selectedDateTime) async {
//     // Parse the selected date time string to a DateTime object
//     DateTime scheduleTime = DateTime.parse(selectedDateTime);
//
//     // Get the current time
//     DateTime currentTime = DateTime.now();
//
//     // Check if the scheduled time is in the future
//     if (scheduleTime.isAfter(currentTime)) {
//       // Tính toán độ trễ cho đến thời gian dự kiến
//       int delay = scheduleTime.difference(currentTime).inSeconds;
//       // Sử dụng bộ hẹn giờ để lên lịch thông báo
//       Timer(Duration(seconds: delay), () async {
//         // Get all tokens
//         List<String> allTokens = await getAllTokens();
//         // Send push messages to all tokens
//         await sendPushMessages(allTokens);
//         // Send the notification
//         _sendscheduleNotification();
//       });
//
//       print('Notification scheduled for: $scheduleTime');
//     } else {
//       print('Selected time must be in the future');
//       // Handle when the selected time is not in the future
//     }
//   }
//
//
// void _sendscheduleNotification() {
//     String title = _titleController.text;
//     String body = _bodyController.text;
//     String scheduletime = _dtimeController.text;
//     // Lưu dữ liệu vào Realtime Database
//     _database.push().set({
//       'title': title,
//       'body': body,
//       'scheduletime': scheduletime,
//       'timestamp': DateTime.now().toString(),
//     });
//   }
//
// SizedBox(height: 20.0),
//             TextFormField(
//               controller: _dtimeController,
//               decoration: InputDecoration(
//                 labelText: 'Selected Date & Time', // Label to indicate selected date and time
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   onPressed: () async {
//                     DateTime? dateTime = await showOmniDateTimePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now().subtract(const Duration(days: 3652)),
//                       lastDate: DateTime.now().add(const Duration(days: 3652)),
//                       is24HourMode: false,
//                       isShowSeconds: false,
//                       minutesInterval: 1,
//                       secondsInterval: 1,
//                       isForce2Digits: true,
//                       borderRadius: const BorderRadius.all(Radius.circular(16)),
//                       constraints: const BoxConstraints(
//                         maxWidth: 350,
//                         maxHeight: 650,
//                       ),
//                       transitionBuilder: (context, anim1, anim2, child) {
//                         return FadeTransition(
//                           opacity: anim1.drive(Tween(begin: 0, end: 1)),
//                           child: child,
//                         );
//                       },
//                       transitionDuration: const Duration(milliseconds: 200),
//                       barrierDismissible: true,
//                       selectableDayPredicate: (dateTime) {
//                         // Disable selecting the current date
//                         return dateTime != DateTime.now();
//                       },
//                     );
//
//                     if (dateTime != null) {
//                       setState(() {
//                         _dtimeController.text = dateTime.toString();
//                       });
//                     }
//
//                     print("Selected dateTime: $dateTime");
//                   },
//                   icon: Icon(Icons.date_range),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await _scheduleshowConfirmationDialog(context);
//               },
//               child: Text("Thông báo theo lịch trình"),
//             ),