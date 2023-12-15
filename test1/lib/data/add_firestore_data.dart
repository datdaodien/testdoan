import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../pages/thongbao/thongbao.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

bool _loading = false; //ref of table
//post wala table ma sabai save hunxa

final _postController = TextEditingController();
final fireStore = FirebaseFirestore.instance.collection('users');

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Firestore data'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: _postController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        _postController.clear();
                      },
                      icon: Icon(Icons.clear)),
                  hintText: 'Write something...',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30),
           ElevatedButton(
                onPressed: () {

                  String id = DateTime.now().millisecondsSinceEpoch.toString();

                  fireStore.doc(id).set({
                    'title': _postController.text.toString(),
                    'id': id
                  }).then((value) {
                    ThongBao()
                        .toastMessage('Data added!');

                  }).onError((error, stackTrace) {
                    ThongBao()
                        .toastMessage('Some error occured!');
                  });
                },
                child: Text('Press me'),
      ),

          ],
        ),
      ),
    );
  }
}