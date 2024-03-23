  import 'package:badges/badges.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:badges/badges.dart' as badges;
  import '../../../api/shared_preferences.dart';
import '../../../api/uid.dart';
  import 'package:firebase_database/firebase_database.dart';
  import 'package:firebase_database/ui/firebase_animated_list.dart';

  class HomeHeader2 extends StatefulWidget {
    const HomeHeader2({super.key});

    @override
    State<HomeHeader2> createState() => _HomeHeader2State();
  }

  class _HomeHeader2State extends State<HomeHeader2> {
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

      final databaseRef = FirebaseDatabase.instance.ref('notifications');
      databaseRef.onChildAdded.listen((event) {
        if (event.snapshot.exists) {
          setState(() {
            String notificationId = event.snapshot.key!;
            bool isSeen = NotificationHelper.isNotificationSeen(notificationId);
            if (!isSeen) {
              notificationCount++;
              hasNewNotification = true;
              NotificationHelper.saveUnreadNotificationCount(notificationCount);
            }
          });
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(CurrentUser().uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Or a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('Không tìm thấy dữ liệu'); // Handle no data case
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
                    NotificationHelper.resetUnreadNotificationCount();
                    setState(() {
                      notificationCount = 0;
                      hasNewNotification = false;
                    });
                    showNotificationDialog(context);
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
                    child: const Icon(Icons.notifications, size: 45),
                  ),
                ),
              ],
            );
          }
        },
      );
    }
    String getTimeDifference(String timestamp) {
      DateTime notificationTime = DateTime.parse(timestamp);
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(notificationTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} phút trước';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} giờ trước';
      } else if (difference.inDays < 2) {
        return '1 ngày trước';
      } else {
        return '${difference.inDays} ngày trước';
      }
    }

    void showNotificationDialog(BuildContext context) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NotificationDialog(notificationCount: notificationCount);
        },
      );
    }
  }

  class NotificationDialog extends StatefulWidget {
    final int notificationCount;
    const NotificationDialog({required this.notificationCount});

    @override
    _NotificationDialogState createState() =>
        _NotificationDialogState(notificationCount);
  }

  class _NotificationDialogState extends State<NotificationDialog> {
    final _searchFiltern = TextEditingController();
    int notificationCount;
    _NotificationDialogState(this.notificationCount);

    @override
    void initState() {
      super.initState();
      _searchFiltern.addListener(onSearchTextChanged);

    }

    @override
    void dispose() {
      _searchFiltern.removeListener(onSearchTextChanged);
      _searchFiltern.dispose();
      super.dispose();
    }

    void onSearchTextChanged() {
      setState(() {
        // Perform search or update UI state here based on _searchFiltern.text
      });
    }
    String getTimeDifference(String timestamp) {
      DateTime notificationTime = DateTime.parse(timestamp);
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(notificationTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} phút trước';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} giờ trước';
      } else if (difference.inDays < 2) {
        return '1 ngày trước';
      } else {
        return '${difference.inDays} ngày trước';
      }
    }

    @override
    Widget build(BuildContext context) {

      final databaseRef = FirebaseDatabase.instance.ref('notifications');

      return Dialog(
        insetPadding: const EdgeInsets.all(0),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _searchFiltern,
                      onChanged: (String value) {
                        // You can remove this as you're handling it in the listener
                      },
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<Object>(
                      stream: databaseRef.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child:  FirebaseAnimatedList(
                                reverse: true,
                                defaultChild:
                                    const Center(child: CircularProgressIndicator()),
                                query: databaseRef.orderByChild('timestamp'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  final title =
                                      snapshot.child('title').value.toString();
                                  final body =
                                      snapshot.child('body').value.toString();
                                  final timestamp =
                                      snapshot.child('timestamp').value.toString();

                                  if (_searchFiltern.text.isEmpty ||
                                      (title.toLowerCase().contains(
                                              _searchFiltern.text.toLowerCase()) ||
                                          body.toLowerCase().contains(
                                              _searchFiltern.text.toLowerCase()))) {
                                    String? notificationId = snapshot.key;
                                    bool isSeen =
                                    NotificationHelper.isNotificationSeen(
                                        notificationId!);
                                    return GestureDetector(
                                      onTap: () {
                                        // Đánh dấu thông báo đã đọc và cập nhật màu sắc
                                        NotificationHelper.markAsSeen(notificationId);
                                        setState(() {
                                          // Cập nhật màu sắc của thông báo sau khi được đánh dấu đã đọc
                                          isSeen = true;
                                        });
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => NotificationDetails(
                                              title: title,
                                              body: body,),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 3,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        color: isSeen ? Colors.white : Colors.grey,
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                body,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            getTimeDifference(timestamp),
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                                shrinkWrap: true,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   right: 0,
              //   bottom: 0,
              //   child: GestureDetector(
              //     onTap: () {
              //
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(
              //         'Đánh dấu tất cả đã đọc',
              //         style: TextStyle(
              //           color: Colors.blue,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    }
  }

  class NotificationDetails extends StatelessWidget {
    final String title;
    final String body;

    const NotificationDetails({required this.title, required this.body});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
  }
