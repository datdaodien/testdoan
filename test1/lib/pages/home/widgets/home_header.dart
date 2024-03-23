import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../api/shared_preferences.dart';
import '../../../api/uid.dart';
import 'package:badges/badges.dart' as badges;

import '../../thongbao/thongbao.dart';

class HomeHeader extends StatefulWidget {
  HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int notificationCount = 0;
  bool hasNewNotification = false;

  @override
  void initState() {
    super.initState();

    // Khởi tạo SharedPreferences
    NotificationHelper.initSharedPreferences();

    // Sử dụng hàm từ NotificationHelper thông qua tên lớp
    NotificationHelper.getUnreadNotificationCount().then((value) {
      setState(() {
        notificationCount = value ?? 0;
        hasNewNotification = notificationCount > 0;
      });
    });

    // final databaseRef = FirebaseDatabase.instance.ref('notifications');
    // databaseRef.onChildAdded.listen((event) {
    //   if (event.snapshot.exists) {
    //     setState(() {
    //       String notificationId = event.snapshot.key!;
    //       bool isSeen = NotificationHelper.isNotificationSeen(notificationId);
    //       if (!isSeen) {
    //         notificationCount++;
    //         hasNewNotification = true;
    //         NotificationHelper.saveUnreadNotificationCount(notificationCount);
    //       }
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(CurrentUser().uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Or a loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('No data found'); // Handle no data case
        } else {
          String rool = snapshot.data!['rool'];
          String userName = snapshot.data!['name'];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Chào mừng $rool'),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    notificationCount = 0;
                    hasNewNotification = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Post2()),
                  );
                },
                child: badges.Badge(
                  badgeAnimation: const BadgeAnimation.rotation(
                      animationDuration: Duration(seconds: 1)),
                  position: BadgePosition.topEnd(top: 0, end: 3),
                  badgeContent: hasNewNotification ? Text(
                    '$notificationCount',
                    style: const TextStyle(color: Colors.white),
                  )
                      : null,
                  child: const Icon(Icons.notifications,size: 45),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
class Post2 extends StatefulWidget {
  const Post2({Key? key});

  @override
  State<Post2> createState() => _PostState();
}

class _PostState extends State<Post2> {
  final _searchFilter = TextEditingController();
  //final _editFilter = TextEditingController();
  final postController = TextEditingController();
  bool loading = false;

  final databaseRef = FirebaseDatabase.instance.ref('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // nút back mở
        centerTitle: true, // căn giữ tiêu đề
        title: const Text("Tạo thông báo"),
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
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(child: CircularProgressIndicator()),
                query: databaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (_searchFilter.text.isEmpty) {
                    return _buildListTile(snapshot, title);
                  } else if (title.toLowerCase().contains(_searchFilter.text.toLowerCase())) {
                    return _buildListTile(snapshot, title);
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
          // Navigator.push(
          //   context,
          //  // MaterialPageRoute(builder: (context) => NotificationScreen()),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListTile _buildListTile(DataSnapshot snapshot, String title) {
    return ListTile(
      title: Text(snapshot.child('title').value.toString()),
      subtitle: Text(snapshot.child('body').value.toString()),
      trailing: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                String? notificationId = snapshot.key;
                databaseRef.child(notificationId!).remove().then((value) {
                  ThongBao().toastMessage('Đã xóa thành công!');
                }).onError((error, stackTrace) {
                  ThongBao().toastMessage('Đã xảy ra lỗi!');
                });
              },
              leading: const Icon(Icons.delete),
              title: const Text('Xóa'),
            ),
          ),
        ],
      ),
    );
  }
}