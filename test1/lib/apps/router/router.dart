import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';
import 'package:test1/data/models.dart';
import 'package:test1/pages/dangnhap/auth_screen.dart';
import 'package:test1/pages/dia_diem/detail_dia_diem/detail_dia_diem_page.dart';
import 'package:test1/pages/dia_diem/dia_diem.dart';
import 'package:test1/pages/dichbenh/add_dich_benh.dart';
import 'package:test1/pages/dichbenh/detail_dich_benh/detail_d%E1%BB%8Bch_benh_page.dart';
import 'package:test1/pages/home/home_page.dart';
import 'package:test1/pages/profile/profile.dart';
import 'package:test1/pages/root_page.dart';
import 'package:test1/pages/thongbao/post.dart';
import '../../pages/dangnhap/widgets/forgot_password.dart';
import '../../pages/dangnhap/widgets/login_phone.dart';
import '../../pages/dia_diem/widgets/add_dia_diem.dart';
import '../../pages/vegetable/detail_vegetable/detail_vegetable_page.dart';
import '../../pages/vegetable/vegetable_page.dart';
import '../../pages/vegetable/widgets/add_vegetable.dart';

/// The route configuration.( Cấu hình tuyến đường.)

class RouterCustom {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        name: RouterName.auth,
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          //AuthScreen()
          return AddDichBenh();
        },
        routes: <RouteBase>[
          GoRoute(
            name: RouterName.loginphone,
            path: 'loginphone',
            builder: (BuildContext context, GoRouterState state) {
              return LoginPhone();
            },
          ),

          GoRoute(
            name: RouterName.forgotpassword,
            path: 'forgotpassword',
            builder: (BuildContext context, GoRouterState state) {
              return ForgotPassword();
            },
          ),

          GoRoute(
            name: RouterName.doipassworrd,
            path: 'doipassworrd',
            builder: (BuildContext context, GoRouterState state) {
              return ForgotPassword();
            },
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) {
          return RootPage(
            child: child,
          );
        },
        routes: [
          GoRoute(
            name: RouterName.home,
            path: '/home',
            builder: (BuildContext context, GoRouterState state) {
              return  HomePage(
              );
            },//gốc
            //cấp1
            routes: <RouteBase>[
              GoRoute(
                name: RouterName.vegetable,
                path: 'vegetable',
                builder: (BuildContext context, GoRouterState state) {
                  return VegetablePage();
                },
                //cấp 2
                routes: <RouteBase>[
                  GoRoute(
                    name: RouterName.detailvegetable,
                    path: 'detailvegetable',
                    builder: (BuildContext context, GoRouterState state) {
                      Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                      return DetailVegetablePage(
                        item: item,
                      );
                    },
                  ),
                  GoRoute(
                    name: RouterName.addvegetable,
                    path: 'addvegetable',
                    builder: (BuildContext context, GoRouterState state) {
                      return AddVegetable();
                    },
                  ),
                ],

              ),

              //cấp 1
              GoRoute(
                name: RouterName.thongbao,
                path: 'thongbao',
                builder: (BuildContext context, GoRouterState state) {
                  return Post();
                },

              ),
              //cấp 1
              GoRoute(
                name: RouterName.profile,
                path: 'profile',
                builder: (BuildContext context, GoRouterState state) {
                  return Profile();
                },

              ),
              //câp1
              GoRoute(
                name: RouterName.diadiem,
                path: 'diadiem',
                builder: (BuildContext context, GoRouterState state) {
                  return DiaDiemPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: RouterName.detaildiadiem,
                    path: 'detaildiadiem',
                    builder: (BuildContext context, GoRouterState state) {
                      print(state);
                      Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                      return DetailDiaDiemPage(
                          item: item
                      );
                    },
                  ),
                  GoRoute(
                    name: RouterName.adddiadiem,
                    path: 'adddiadiem',
                    builder: (BuildContext context, GoRouterState state) {
                      return AddDiaDiem(
                      );
                    },
                  ),
                ],

              ),
              //câp 1
              GoRoute(
                name: RouterName.dichbenh,
                path: 'dichbenh',
                builder: (BuildContext context, GoRouterState state) {
                  return VegetablePage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: RouterName.detaildichbenh,
                    path: 'detaildichbenh',
                    builder: (BuildContext context, GoRouterState state) {
                      Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                       return DetailDichBenhPage(item: item);
                    },
                  ),
                  GoRoute(
                    name: RouterName.adddichbenh,
                    path: 'adddichbenh',
                    builder: (BuildContext context, GoRouterState state) {
                       return AddDichBenh();
                    },
                  ),
                ],

              ),
            ],

          ),


          GoRoute(
            name: RouterName.vegetablemenu,
            path: '/vegetablemenu',
            builder: (BuildContext context, GoRouterState state) {
              return const VegetablePage();
            },
            routes: <RouteBase>[
              GoRoute(
                name: RouterName.detailvegetablemenu,
                path: 'detailvegetablemenu',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                  return DetailVegetablePage(
                    item: item,
                  );
                },
              ),
            ],
          ),



        ],
      ),
    ],
  );
}
