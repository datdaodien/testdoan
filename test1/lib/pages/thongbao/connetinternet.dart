import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:test1/pages/thongbao/thongbao.dart'; // Import class ThongBao


class ConnecInternet {
  static bool isConnected = true; // Biến để theo dõi trạng thái kết nối

  static Future<void> checkInternetConnection() async {
    const duration = Duration(seconds: 5); // Thời gian giữa mỗi lần kiểm tra 5 giây
    Timer.periodic(duration, (timer) async {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none && isConnected) {
        // Chuyển từ trạng thái có kết nối sang không có kết nối
        isConnected = false;
        print('Không có kết nối internet!');
        ThongBao().toastMessage('Không có kết nối internet');
      } else
      if (connectivityResult != ConnectivityResult.none && !isConnected) {
        // Chuyển từ trạng thái không có kết nối sang có kết nối
        isConnected = true;
        print('Đã kết nối internet!');
        ThongBao().toastMessage('Đã kết nối lại');
        timer.cancel();
      }
    });
  }
}

// void startCheckingInternetConnection() {
//   const duration = Duration(seconds: 5); // Thời gian giữa mỗi lần kiểm tra 5 giây
//   Timer.periodic(duration, (timer) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       // Không có kết nối internet
//       print('Không có kết nối internet!');
//       ThongBao().toastMessage('Không có kết nối internet');
//     } else {
//       // Có kết nối internet, dừng vòng lặp kiểm tra
//       print('Đã kết nối internet!');
//       ThongBao().toastMessage('Đã kết nối lại');
//       timer.cancel();
//     }
//   });
// }