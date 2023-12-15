import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:test1/pages/thongbao/thongbao.dart';
import '../../data/firestore_list_screen.dart';
import '../../test/home1.dart';
import 'loading.dart';

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

  final databaseRef = FirebaseDatabase.instance.ref('portaaaaa');

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
        title: Text("Tao thong bao"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: postController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "hãy nhập thông báo",
              ),
            ),
            loading
                ? Loading()
                : ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        loading = true;
                      });
//DateTime.now().microsecondsSinceEpoch.toString() lấy tg theo tg lúc tạo làm
                      DateTime now = DateTime.now();
                      String formattedDate = "${now.hour}:${now.minute}:${now.second} ${now.day}-${now.month}-${now.year}";
                      String id = formattedDate.toString();
                      databaseRef.child(id).child('con').set({
                        'id': id,
                        'tite': postController.text.toString(),
                      }).then((value) {

                        ThongBao().toastMessage('cổng được thêm vào');
                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        ThongBao().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    child: Text('thông báo'), // Văn bản của nút
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _searchFilter,
                onChanged: (String? value) {
                  // setState(() {});
                  setState(() {});
                },
                decoration: InputDecoration(
                    hintText: 'tìm kiếm', border: OutlineInputBorder()),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Center(
                  child: CircularProgressIndicator(),
                ),
                query: databaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final title =
                      snapshot.child('con').child('tite').value.toString();
                  if (_searchFilter.text.isEmpty) {
                    // Xử lý dữ liệu từ snapshot và hiển thị
                    return ListTile(
                      title: Text(
                          snapshot.child('con').child('tite').value.toString()),
                      subtitle: Text(
                          snapshot.child('con').child('id').value.toString()),
                      trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: (() {
                                        Navigator.pop(context);
                                        _showMyDialog(
                                            title,
                                            snapshot.child('con')
                                                .child('id')
                                                .value
                                                .toString());
                                      }),
                                      leading: Icon(Icons.edit),
                                      title: Text('Cập nhật'),
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        databaseRef
                                            .child(snapshot.child('con')
                                                .child('id')
                                                .value
                                                .toString())
                                            .remove()
                                            .then((value) {
                                          ThongBao().toastMessage(
                                              'Đã xóa thành công!');
                                        }).onError((error, stackTrace) {
                                          ThongBao()
                                              .toastMessage('Đã xảy ra lỗi!');
                                        });
                                      },
                                      leading: Icon(Icons.delete),
                                      title: Text('Xóa'),
                                    )),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(_searchFilter.text.toLowerCase())) {
                    return ListTile(
                      title: Text(
                          snapshot.child('con').child('tite').value.toString()),
                      subtitle: Text(
                          snapshot.child('con').child('id').value.toString()),
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
              MaterialPageRoute(builder: (context) => FirestoreScreen()),
            );
          },
          child: Icon(Icons.add)),
    );
  }
//
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
              decoration: InputDecoration(
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
                databaseRef.child(id).child('con')
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

//Expanded(
//               child: StreamBuilder(
//                 stream: databaseRef.onValue,
//                 builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                   if (!snapshot.hasData) {
//                     return CircularProgressIndicator();
//                   } else {
//                     Map<dynamic, dynamic> map =
//                         snapshot.data!.snapshot.value as dynamic;
//                     List<dynamic> list = [];
//                     list.clear();
//                     list = map.values.toList();
//                   }
//                   return ListView.builder(
//                     itemCount: snapshot.data!.snapshot.children.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(list[index]['tite']),
//                         subtitle: Text(list[index]['id']),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
