import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';
import 'package:test1/data/data_ao.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeList extends StatefulWidget {
   HomeList({super.key});

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // dùng cho 2 p tử trở lên có thể cuộn
      itemCount: data.length, // lay ra soo pha tu bang do dai dl
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // trục phụ 2 phần tử
        mainAxisSpacing: 15, //cách giữa các thag trong cột
        crossAxisSpacing: 15,
        childAspectRatio: 1 / 1, // kích thức cũng như ti lệ 1 ô
      ),

      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            final item = data[index];
            String routeName = '';
            // Xác định routeName dựa trên giá trị title của item
            switch (item.title) {
              case 'Thông tin liên hệ':
                routeName = RouterName.profileadmin;
                break;
              case 'Rau củ':
                routeName = RouterName.vegetable;
                break;
              case 'Địa Điểm':
                routeName = RouterName.diadiem;
                break;
              case 'Dịch Bệnh':
                routeName = RouterName.dichbenh;
                break;
              case 'Thống Kê':
                routeName = RouterName.thongke;
                break;
              case 'Thông Báo':
                routeName = RouterName.thongbao;
                //routeName = RouterName.thongbao;
                break;

              case 'Cài Đặt':

                break;
              // Thêm các trường hợp khác tương ứng với title của từng mục trong danh sách data
              default:
                // Nếu không khớp với bất kỳ giá trị nào, bạn có thể xác định một route mặc định hoặc không làm gì cả.
                break;
            }
            // Chuyển hướng tới routeName đã xác định
            context.goNamed(routeName);
          },

          //   context.goNamed(RouterName.vegetable, extra: data[index]);
          // },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //đưa tất cả lên đầu
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge, // cat anh
                  width: double.infinity, // tang rong theo chiuf ngang
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(1, 1),
                        // Điểm bắt đầu của đổ bóng (tọa độ X, Y)
                        color: Colors.grey.shade200,
                        // Màu của bóng đổ
                        blurRadius: 2,
                        // Bán kính làm mờ (độ mờ của bóng đổ)
                        spreadRadius: 2, // Bán kính trải rộng của bóng đổ
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    fit: BoxFit.cover,
                    image: data[index].image,
                  ),
                ),
              ), //dunng để bao hết nó lai
              const SizedBox(height: 5),
              Text(

                data[index].title,
                style: TextStyle(
                  fontSize: 15,
                ),
                maxLines: 1, // maxLines tối dđa chỉ 1 dòng
                overflow: TextOverflow
                    .ellipsis, // 1 dòng nếu quá đài thì theo sau nó là 3 chấm.
              ),
            ],
          ),
        );
      },
    );
  }
}
