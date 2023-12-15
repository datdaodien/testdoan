import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // // for accessing cloud firestore database
  // static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  // // for accessing firebase storage
  // static FirebaseStorage storage = FirebaseStorage.instance;
}
//Để làm điều này, bạn có thể sử dụng Google Maps URL Scheme để mở ứng dụng Google Maps và điều hướng đến địa chỉ cụ thể khi người dùng nhấn nút trong ứng dụng của bạn. Dưới đây là cách thực hiện điều này trong Flutter:
//
// Đầu tiên, bạn cần một TextField để người dùng nhập địa chỉ:
//
// dart
// Copy code
// TextEditingController addressController = TextEditingController();
//
// TextField(
//   controller: addressController,
//   decoration: InputDecoration(
//     hintText: 'Nhập địa chỉ của bạn',
//     // Các thuộc tính trang trí khác cho TextField
//   ),
// ),
// Sau đó, khi người dùng nhấn nút để chuyển đến Google Maps, bạn có thể sử dụng url_launcher để mở Google Maps với địa chỉ đã nhập:
//
// dart
// Copy code
// import 'package:url_launcher/url_launcher.dart';
//
// ElevatedButton(
//   onPressed: () {
//     String address = addressController.text;
//     openMaps(address);
//   },
//   child: Text('Mở địa chỉ trên Google Maps'),
// ),
// Hàm openMaps sẽ mở ứng dụng Google Maps với địa chỉ được chuyển đến:
//
// dart
// Copy code
// void openMaps(String address) async {
//   String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$address';
//   if (await canLaunch(googleUrl)) {
//     await launch(googleUrl);
//   } else {
//     throw 'Không thể mở Google Maps';
//   }
// }
// Khi người dùng nhấn nút, nó sẽ mở ứng dụng Google Maps và tìm kiếm địa chỉ đã nhập trong Google Maps.






// final Rx<List<Category>> _categories = Rx<List<Category>>([]);
//   List<Category> get categories => _categories.value;
//
//   getCategories(String keySearch) async {
//     if (keySearch.isEmpty) {
//       _categories.bindStream(
//         firestore.collection('categories').snapshots().map(
//               (QuerySnapshot query) {
//             List<Category> retValue = [];
//             for (var element in query.docs) {
//               retValue.add(Category.fromSnap(element));
//               print(element);
//             }
//             return retValue;
//           },
//         ),
//       );
//     } else {
//       _categories.bindStream(firestore
//           .collection('categories')
//           .orderBy('name')
//           .snapshots()
//           .map((QuerySnapshot query) {
//         List<Category> retVal = [];
//         for (var elem in query.docs) {
//           String name = elem['name'].toLowerCase();
//           String search = keySearch.toLowerCase().trim();
//           if (name.contains(search)) {
//             retVal.add(Category.fromSnap(elem));
//           }
//         }
//         return retVal;
//       }));
//     }
//   }