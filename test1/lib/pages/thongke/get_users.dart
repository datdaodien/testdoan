
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getAllUserData() async {
  List<Map<String, dynamic>> allUserData = [];

  try {
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance.collection('users').where('rool', isNotEqualTo: 'admin').get(); // Lọc các người dùng không có role là admin
    print(userSnapshots.docs.map((doc) => doc.data()).toList());
    for (QueryDocumentSnapshot userDoc in userSnapshots.docs) {
      // Lấy UID của mỗi user
      String uid = userDoc.id;
      Map<String, dynamic> userInformation =
      userDoc.data() as Map<String, dynamic>;

      String hinh = userInformation['hinh'] ?? '';
      String diachi = userInformation['diachi'] ?? '';

      // Lấy dữ liệu từ collection 'vegetable' của mỗi user
      QuerySnapshot vegetableSnapshot = await userDoc.reference.collection('vegetable').get();
      int numberOfVegetables = vegetableSnapshot.docs.length;
      List<Map<String, dynamic>> userData = [];
      int totalNumberOfDiseases = 0;
      for (QueryDocumentSnapshot vegetableDoc in vegetableSnapshot.docs) {
        String vegetableId = vegetableDoc.id;
        Map<String, dynamic> vegetableData = vegetableDoc.data() as Map<String, dynamic>;

        // Lấy số lượng dịch bệnh của loại cây trồng này
        QuerySnapshot diseaseSnapshot = await vegetableDoc.reference.collection('dichbenh').get();
        int numberOfDiseases = diseaseSnapshot.docs.length;

        List<Map<String, dynamic>> diseasesData = [];
        for (QueryDocumentSnapshot diseaseDoc in diseaseSnapshot.docs) {
          String diseaseId = diseaseDoc.id;
          Map<String, dynamic> diseaseData =
          diseaseDoc.data() as Map<String, dynamic>;

          diseasesData.add({
            'diseaseId': diseaseId,
            'tendichbenh': diseaseData['tendichbenh'],
            // Thêm thông tin cần thiết khác nếu có
          });
        }
        // Thêm thông tin của loại cây trồng và số lượng dịch bệnh vào danh sách userData
        Map<String, dynamic> vegetableInfo = {
          'vegetableId': vegetableId,
          'vegetableData': vegetableData,
          'numberOfDiseases': numberOfDiseases,
          'diseasesData': diseasesData,
        };
        userData.add(vegetableInfo);

        // Cộng dồn số lượng dịch bệnh vào biến tổng
         totalNumberOfDiseases += numberOfDiseases;
      }

      // Tạo một Map chứa thông tin của mỗi user về các loại cây trồng và số lượng dịch bệnh
      Map<String, dynamic> userInfo = {
        'uid': uid,
        'hinh':hinh,
        'diachi':diachi,
        "numberOfVegetables": numberOfVegetables,
        'totalNumberOfDiseases':totalNumberOfDiseases,
        'userData': userData,

      };


      // Thêm thông tin của mỗi user vào danh sách allUserData
      allUserData.add(userInfo);
    }
  } catch (e) {
    print('Error fetching all user data: $e');
  }
  allUserData.sort((a, b) => b['totalNumberOfDiseases'].compareTo(a['totalNumberOfDiseases']));

  return allUserData;

}