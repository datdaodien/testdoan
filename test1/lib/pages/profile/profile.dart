import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../data/add_firestore_data.dart';
import '../thongbao/connetinternet.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Stream<DocumentSnapshot<Map<String, dynamic>>> _getUserDataStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc("GqRyx5r76kW2W0eboPUC56Ej5sG2")
        .snapshots();;
  }

  int calculateAge(String birthDate) {
    List<String> dateParts = birthDate.split('/'); // Tách ngày, tháng, năm
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    DateTime today = DateTime.now();
    DateTime birthday =
    DateTime(year, month, day); // Tạo DateTime từ ngày/tháng/năm
    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
     ConnecInternet.checkInternetConnection();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getUserDataStream(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(userData['hinh']),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Transform.translate(
                        offset: Offset(10, 10),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey[400]),
                            onPressed: () {
                              // updata(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                userData['name'].toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20, // Kích thước chữ
                  fontWeight: FontWeight.bold, // Độ đậm của chữ
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Thông tin chi tiết',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(left: 15, bottom: 15),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {

                            },
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['name'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(left: 15, bottom: 15),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['email'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(left: 15, bottom: 15),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tuổi: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(calculateAge(userData['tuoi']).toString())
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(left: 15, bottom: 15),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số Điện Thoại: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['sdt'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(left: 15, bottom: 15),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Địa Chỉ: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['diachi'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(left: 15, bottom: 15),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cây trồng: ",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(userData['uid'] ?? 'Chưa cập nhật')
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }


  // void updata(BuildContext context) async {
  //   // Tạo các TextEditingController và gán giá trị ban đầu từ item vào TextField
  //   TextEditingController nameController =
  //   TextEditingController(text: userData['name']);
  //   TextEditingController tuoiController =
  //   TextEditingController(text: userData['tuoi']);
  //   TextEditingController emailController =
  //   TextEditingController(text: userData['email']);
  //   TextEditingController diachiController =
  //   TextEditingController(text: userData['diachi']);
  //   TextEditingController sdtController =
  //   TextEditingController(text: userData['sdt']);
  //   // Tạo các TextEditingController cho các trường còn lại và gán giá trị tương ứng
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return AlertDialog(
  //               title: Text('Cập Nhật Thông Tin'),
  //               content: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () async {
  //                         showModalBottomSheet(
  //                           context: context,
  //                           builder: (BuildContext context) {
  //                             return SafeArea(
  //                               child: Column(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: <Widget>[
  //                                   ListTile(
  //                                     leading: Icon(Icons.photo_library),
  //                                     title: Text('Chọn từ thư viện'),
  //                                     onTap: () async {
  //                                       await _getImage(ImageSource.gallery);
  //                                       Navigator.pop(context);
  //                                       setState(
  //                                               () {}); // Cập nhật giao diện sau khi chọn ảnh
  //                                     },
  //                                   ),
  //                                   ListTile(
  //                                     leading: Icon(Icons.photo_camera),
  //                                     title: Text('Chụp ảnh mới'),
  //                                     onTap: () async {
  //                                       await _getImage(ImageSource.camera);
  //                                       Navigator.pop(context);
  //                                       setState(
  //                                               () {}); // Cập nhật giao diện sau khi chụp ảnh
  //                                     },
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                         );
  //                       },
  //                       child: Stack(
  //                         children: [
  //                           Container(
  //                             width: 150,
  //                             height: 150,
  //                             decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               border: Border.all(
  //                                 color: Colors.white70,
  //                                 width: 2.0,
  //                               ),
  //                             ),
  //                             child: ClipOval(
  //                               child: _imageFile != null
  //                                   ? Image.file(
  //                                 _imageFile!,
  //                                 fit: BoxFit.cover,
  //                                 width: 200,
  //                                 height: 200,
  //                               )
  //                                   : FadeInImage.memoryNetwork(
  //                                 placeholder: kTransparentImage,
  //                                 image: userData['hinh'],
  //                                 fit: BoxFit.cover,
  //                                 width: 200,
  //                                 height: 200,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     TextField(
  //                       controller: nameController,
  //                       decoration: InputDecoration(labelText: 'Tên'),
  //                     ),
  //                     TextField(
  //                       controller: tuoiController,
  //                       keyboardType: TextInputType.datetime,
  //                       decoration: InputDecoration(labelText: 'Tuổi',
  //                         suffixIcon: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: InkWell(
  //                             onTap: () async {
  //                               final selectedDate = await showDatePicker(
  //                                 context: context,
  //                                 initialDate: DateTime.now(),
  //                                 firstDate: DateTime(1900),
  //                                 lastDate: DateTime.now(),
  //                               );
  //                               if (selectedDate != null) {
  //                                 final formattedDate =
  //                                 DateFormat('dd/MM/yyyy').format(selectedDate);
  //                                 tuoiController.text = formattedDate;
  //                               }
  //                             },
  //                             child: Icon(Icons.calendar_today),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     TextField(
  //                       readOnly: true,
  //                       controller: emailController,
  //                       decoration: InputDecoration(labelText: 'Email'),
  //                     ),
  //                     TextField(
  //                       keyboardType: TextInputType.number,
  //                       maxLength: 10,
  //                       inputFormatters: [
  //                         FilteringTextInputFormatter.digitsOnly,
  //                         // Chỉ cho phép nhập số
  //                         LengthLimitingTextInputFormatter(10),
  //                         // Giới hạn tối đa 10 ký tự
  //                       ],
  //                       controller: sdtController,
  //                       decoration: InputDecoration(labelText: 'Số điện thoại'),
  //                     ),
  //                     TextField(
  //                       maxLines: 1,
  //                       controller: diachiController,
  //                       decoration: InputDecoration(labelText: 'Địa chỉ'),
  //                     ),
  //
  //                     // Thêm các TextField khác với controller tương ứng ở đây
  //                   ],
  //                 ),
  //               ),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('Hủy'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: isLoading
  //                       ? null
  //                       : () async {
  //                     setState(() {
  //                       isLoading = true;
  //                     });
  //                     String newName = nameController.text;
  //                     String newTuoi = tuoiController.text;
  //                     String newDiachi = diachiController.text;
  //                     String newSdt = sdtController.text;
  //                     if (_imageFile != null) {
  //                       Reference imageRef = FirebaseStorage.instance
  //                           .ref()
  //                           .child("hinhuser")
  //                           .child("/${userData['uid']}.jpg");
  //                       UploadTask uploadTask = imageRef.putFile(_imageFile!);
  //                       TaskSnapshot snapshot = await uploadTask;
  //                       var newUrl = await snapshot.ref.getDownloadURL();
  //
  //                       await _storeref.doc(userData['uid']).update({
  //                         'name': newName,
  //                         'tuoi': newTuoi,
  //                         'diachi': newDiachi,
  //                         'sdt': newSdt,
  //                         'hinh': newUrl, // Lưu URL mới vào Firestore
  //                       });
  //                     } else {
  //                       // Trường hợp không có hình mới, chỉ cập nhật thông tin người dùng
  //                       await _storeref.doc(userData['uid']).update({
  //                         'name': newName,
  //                         'tuoi': newTuoi,
  //                         'diachi': newDiachi,
  //                         'sdt': newSdt,
  //                       });
  //                     }
  //                     setState(() {
  //                       isLoading = false;
  //                     });
  //                     // Hiển thị thông báo
  //                     ThongBao().toastMessage('Đã update thành công!');
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: isLoading ? CircularProgressIndicator() : Text(
  //                       'Lưu'),
  //                 ),
  //               ],
  //             );
  //           });
  //     },
  //   );
  // }
}
