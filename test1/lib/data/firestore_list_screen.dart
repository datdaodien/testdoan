
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/pages/dangnhap/auth_screen.dart';
import 'package:test1/pages/thongbao/thongbao.dart';
import 'package:test1/test/home1.dart';

import 'add_firestore_data.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final _auth = FirebaseAuth.instance;

  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference _ref = FirebaseFirestore.instance.collection('users');

  final _editFilter = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        SystemNavigator.pop();
        return true;
      }),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home1()),
            );
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Firestore list screen'),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       Get.defaultDialog(
            //           title: 'Log Out?',
            //           content: Column(
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   TextButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       child: Text('Cancel')),
            //                   TextButton(
            //                       onPressed: () {
            //                         //logout feature
            //                         _auth.signOut().then((value) {
            //                           ThongBao()
            //                               .toastMessage('Successfully logged out');
            //
            //                         }).onError((error, stackTrace) {
            //                           ThongBao()
            //                               .toastMessage(error.toString());
            //                         });
            //                       },
            //                       child: Text('Log out'))
            //                 ],
            //               )
            //             ],
            //           ));
            //     },
            //     icon: Icon(Icons.logout)),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  ThongBao().toastMessage('Some error occured!');
                }
                return Expanded(
                  //needs to be wrapped with expanded widget
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              _ref
                                  .doc(snapshot.data!.docs[index]['id']
                                  .toString())
                                  .update({
                                'title': "Pranesh",
                              }).then((value) {
                                ThongBao().toastMessage('Updated');
                              }).onError((error, stackTrace) {
                                ThongBao().toastMessage('Error!');
                              });
                            },
                            onLongPress: () {
                              _ref
                                  .doc(snapshot.data!.docs[index]['id']
                                  .toString())
                                  .delete()
                                  .then((value) {
                                ThongBao().toastMessage('Deleted!');
                              }).onError((error, stackTrace) {
                                ThongBao().toastMessage('Error!');
                              });
                            },
                            leading:
                            Icon(Icons.precision_manufacturing_outlined),
                            subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString()),
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                          );
                        }));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String title, String id) async {
    _editFilter.text = title;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update'),
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}