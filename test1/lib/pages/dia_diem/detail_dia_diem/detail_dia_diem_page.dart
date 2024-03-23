import 'dart:io';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/pages/dia_diem/detail_dia_diem/detail_dia_dien_vetetable_page.dart';
import 'package:test1/pages/thongbao/thongbao.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../apps/router/routername.dart';
import '../../thongbao/connetinternet.dart';

// ignore: must_be_immutable
class DetailDiaDiemPage extends StatefulWidget {
  final Map<String, dynamic> item;

  DetailDiaDiemPage({required this.item});

  @override
  State<DetailDiaDiemPage> createState() => _DetailDiaDiemPageState();
}

class _DetailDiaDiemPageState extends State<DetailDiaDiemPage> {
  CollectionReference _storeref =
      FirebaseFirestore.instance.collection('users');


  File? _imageFile;
  bool isLoading = false;
  ImagePicker picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void updata(BuildContext context) async {
    TextEditingController nameController =
        TextEditingController(text: widget.item['name']);
    TextEditingController tuoiController =
        TextEditingController(text: widget.item['tuoi']);
    TextEditingController emailController =
        TextEditingController(text: widget.item['email']);
    TextEditingController diachiController =
        TextEditingController(text: widget.item['diachi']);
    TextEditingController sdtController =
        TextEditingController(text: widget.item['sdt']);
    // Tạo các TextEditingController cho các trường còn lại và gán giá trị tương ứng

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Cập Nhật Thông Tin'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Chọn từ thư viện'),
                                  onTap: () async {
                                    await _getImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                    setState(
                                        () {}); // Cập nhật giao diện sau khi chọn ảnh
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Chụp ảnh mới'),
                                  onTap: () async {
                                    await _getImage(ImageSource.camera);
                                    Navigator.pop(context);
                                    setState(
                                        () {}); // Cập nhật giao diện sau khi chụp ảnh
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white70,
                              width: 2.0,
                            ),
                          ),
                          child: ClipOval(
                            child: _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  )
                                : FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: widget.item['hinh'],
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên'),
                  ),
                  TextField(
                    controller: tuoiController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Tuổi',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              final formattedDate =
                                  DateFormat('dd/MM/yyyy').format(selectedDate);
                              tuoiController.text = formattedDate;
                            }
                          },
                          child: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Chỉ cho phép nhập số
                      LengthLimitingTextInputFormatter(10),
                      // Giới hạn tối đa 10 ký tự
                    ],
                    controller: sdtController,
                    decoration:
                        const InputDecoration(labelText: 'Số điện thoại'),
                  ),
                  TextField(
                    maxLines: 1,
                    controller: diachiController,
                    decoration: const InputDecoration(labelText: 'Địa chỉ'),
                  ),

                  // Thêm các TextField khác với controller tương ứng ở đây
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        String newName = nameController.text;
                        String newTuoi = tuoiController.text;
                        String newDiachi = diachiController.text;
                        String newSdt = sdtController.text;
                        if (_imageFile != null) {
                          Reference imageRef = FirebaseStorage.instance
                              .ref()
                              .child("hinhuser")
                              .child("/${widget.item['uid']}.jpg");
                          UploadTask uploadTask = imageRef.putFile(_imageFile!);
                          TaskSnapshot snapshot = await uploadTask;
                          var newUrl = await snapshot.ref.getDownloadURL();

                          await _storeref.doc(widget.item['uid']).update({
                            'name': newName,
                            'tuoi': newTuoi,
                            'diachi': newDiachi,
                            'sdt': newSdt,
                            'hinh': newUrl, // Lưu URL mới vào Firestore
                          });
                        } else {
                          // Trường hợp không có hình mới, chỉ cập nhật thông tin người dùng
                          await _storeref.doc(widget.item['uid']).update({
                            'name': newName,
                            'tuoi': newTuoi,
                            'diachi': newDiachi,
                            'sdt': newSdt,
                          });
                        }
                        // Hiển thị thông báo
                        context.goNamed(RouterName.diadiem);

                        ThongBao().toastMessage('Đã update thành công!');
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Lưu'),
              ),
            ],
          );
        });
      },
    );
  }

  //tính tuổi
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

  Stream<QuerySnapshot> _getUserDataStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    ConnecInternet.checkInternetConnection();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Thông Tin Người Dùng'),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getUserDataStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: [
              const SizedBox(
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
                      backgroundImage: NetworkImage(widget.item['hinh']),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Transform.translate(
                        offset: const Offset(10, 10),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey[400]),
                            onPressed: () {
                              updata(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.item['name'].toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20, // Kích thước chữ
                  fontWeight: FontWeight.bold, // Độ đậm của chữ
                ),
              ),
              const SizedBox(
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
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                            onPressed: () {},
                            icon: Icon(Icons.settings, color: Colors.grey[400]))
                      ],
                    ),
                    Text(widget.item['name'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    Text(widget.item['email'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    Text(calculateAge(widget.item['tuoi']).toString())
                    //hàm tính tuổi
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    Text(widget.item['sdt'] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    Text(widget.item["diachi"] ?? 'Chưa cập nhật')
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DetailDiaDiemVegetable(item:(){})),
                  // );
                   //context.goNamed(RouterName.detaildiadiemvegetable);
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailDiaDiemVegetable(item: widget.item,)),
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                              onPressed: () {
                                showCustomDialog(context);
                              },
                              icon: Icon(Icons.settings, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.item['uid'])
                              .collection('vegetable')
                              .get(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Text('Không có cây trồng nào');
                            } else {
                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                                  String vegetableName ="+ ${data['tenvegetable']}.";
                                  return Text(vegetableName);
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    Set<String> selectedVegetables = {}; // Set để lưu các cây trồng đã chọn
    List<bool> isSelectedList = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('vegetable').get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            isSelectedList = List<bool>.filled(snapshot.data!.docs.length, false);

            return AlertDialog(
              title: Text('Thêm cây trồng.'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.hasData
                    ? snapshot.data!.docs.asMap().entries.map((entry) {
                  int index = entry.key;
                  DocumentSnapshot document = entry.value;
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String vegetableID = document.id;
                  String vegetableName = data['tenvegetable'];
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSelectedList[index] = !isSelectedList[index];
                        if (isSelectedList[index]) {
                          selectedVegetables.add(vegetableID);
                          selectedVegetables.add(vegetableName);
                        } else {
                          selectedVegetables.remove(vegetableID);
                          selectedVegetables.remove(vegetableName);
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return isSelectedList[index] ? Colors.green : Colors.grey;
                        },
                      ),
                    ),
                    child: Text(
                      vegetableName,
                      style: TextStyle(
                        color: isSelectedList[index] ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList()
                    : [],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog khi nhấn nút Hủy
                  },
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý lưu dữ liệu khi nhấn nút Lưu
                    saveSelectedVegetables(selectedVegetables.toList());
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> saveSelectedVegetables(List<String> selectedVegetables) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(
        widget.item['uid']);
    final vegetableRef = userDocRef.collection('vegetable');

    for (String vegetableID in selectedVegetables) {
      // Fetch the details of the selected vegetable
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(
          'vegetable').doc(vegetableID).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String vegetableName = data['tenvegetable'];

        // For each selected vegetable, store its ID and name under the 'vegetable' collection
        await vegetableRef.doc(vegetableID).set({
          'vid': vegetableID,
          'tenvegetable': vegetableName,
          // Other details if needed
        });
      }
    }
  }
}
