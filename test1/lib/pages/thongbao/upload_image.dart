import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:test1/pages/thongbao/thongbao.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  bool _loading = false;

  final picker = ImagePicker();
  final databaseRef =
  FirebaseDatabase.instance.ref('portaaaaa'); //database reference
  firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;

  Future getGalleryImage() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No file picked!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration:
                BoxDecoration(border: Border.all(color: Colors.black)),
                child: (_image != null)
                    ? Image.file(_image!.absolute)
                    : Center(
                  child: Icon(
                    Icons.image,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/pranesh' + DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask =
                ref.putFile(_image!.absolute);

                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();//lấy đường link hình

                  databaseRef.child('con').child('1').set(
                      {'id': '1212', 'title': newUrl.toString()}).then((value) {
                    setState(() {
                      _loading = false;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      _loading = false;
                    });
                  });

                  ThongBao().toastMessage('Photo Uploaded!');
                });
              },
              child: Text('Press me'),
          )
        ],
      ),
    );
  }
}