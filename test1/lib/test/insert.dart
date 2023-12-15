import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home1.dart';


class ccreate extends StatefulWidget {
  @override
  State<ccreate> createState() => ccreateState();
}

class ccreateState extends State<ccreate> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  DatabaseReference? dbRef;
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${name.text}.jpg");

      UploadTask task = imagefile.putFile(file!);

      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        Map<String, String> Contact = {
          'name': name.text,
          'number': number.text,
          'url': url,
        };
        dbRef!.push().set(Contact).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Home1(),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('contacts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Contacts',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  height: 200,
                  width: 200,
                  child: file == null
                      ? IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 90,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      getImage();
                    },
                  )
                      : MaterialButton(
                    height: 100,
                    child: Image.file(
                      file!,
                      fit: BoxFit.fill,
                    ),
                    onPressed: () {
                      getImage();
                    },
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Name',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: number,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Number',
              ),
              maxLength: 10,
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 40,
              onPressed: () {
                getImage();
                if (file != null) {
                  uploadFile();
                }
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              color: Colors.indigo[900],
            ),
          ],
        ),
      ),
    );
  }


}
// Future<void> signUp() async {
//     try {
//       final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text.toString(),
//         password: '123456',
//       );
//
//       if (userCredential != null) {
//         String uid = userCredential.user!.uid; // Lấy UID từ UserCredential
//
//         ThongBao().toastMessage('Đã thêm tài khoản!');
//         postDetailsToFirestore(uid);
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (error) {
//       ThongBao().toastMessage('Đã xảy ra lỗi!');
//       setState(() {
//         isLoading = false;
//       });
//       print(error.toString());
//     }
//   }
//   Future<void> _getImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     setState(() {
//       if (pickedFile != null) {
//         _imageFile = File(pickedFile.path);
//       }
//     });
//   }
//
//
//   void postDetailsToFirestore(String uid) async {
//     if (_imageFile == null) {
//       ThongBao().toastMessage('Vui lòng chọn hình ảnh!');
//       return;
//     }
//    setState(() {
//      isLoading = true;
//    });
//     Reference imagefile = FirebaseStorage.instance.ref().child("hinhuser").child("/${uid.toString()}.jpg");
//     UploadTask task = imagefile.putFile(_imageFile!);
//      var newUrl = await imagefile.getDownloadURL();
//
//      await reff.doc(uid.toString()).set({
//         'hình': newUrl.toString(),
//         'name': nameController.text.toString(),
//         'tuoi': tuoiController.text.toString(),
//         'email': emailController.text.toString(),
//         'sdt': sdtController.text.toString(),
//         'uid': uid.toString(),
//         'diachi': diachiController.text.toString(),
//         'rool': "user",
//         }).then((value) async {
//        setState(() {
//          isLoading = false;
//        });
//         ThongBao()
//            .toastMessage('Data added!');
//           context.goNamed(RouterName.diadiem);
//         setState(() {
//           isLoading = false;
//         });
//      }).onError((error, stackTrace) {
//        ThongBao()
//            .toastMessage('Some error occured!');
//        setState(() {
//          isLoading = false;
//        });
//      });
//
//   }



