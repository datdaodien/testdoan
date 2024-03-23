import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test1/apps/router/routername.dart';
import 'package:test1/pages/dangnhap/auth_screen.dart';
import 'package:test1/pages/dangnhap/widgets/doi_passwrd.dart';
import 'package:test1/pages/dia_diem/detail_dia_diem/detail_dia_diem_page.dart';
import 'package:test1/pages/dia_diem/dia_diem.dart';
import 'package:test1/pages/dichbenh/add_dich_benh.dart';
import 'package:test1/pages/dichbenh/detail_dich_benh/detail_d%E1%BB%8Bch_benh_page.dart';
import 'package:test1/pages/home/home_page.dart';
import 'package:test1/pages/profile/profile.dart';
import 'package:test1/pages/profileadmin/profileadmin.dart';
import 'package:test1/pages/root_page.dart';
import 'package:test1/pages/thongbao/post.dart';
import '../../pages/dangnhap/widgets/forgot_password.dart';
import '../../pages/dangnhap/widgets/login_phone.dart';
import '../../pages/dia_diem/widgets/add_dia_diem.dart';
import '../../pages/dichbenh/dich_benh_page.dart';
import '../../pages/home2/home2_page.dart';
import '../../pages/profileadmin/profileadmin2.dart';
import '../../pages/root_page2.dart';
import '../../pages/thongke/thongkho.dart';
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
          return const AuthScreen();
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
              return DoiPassword();
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
                  return const Post();
                },

              ),
              GoRoute(
                name: RouterName.thongke,
                path: 'thongke',
                builder: (BuildContext context, GoRouterState state) {
                  return YourScreen();
                },

              ),
              //cấp 1
              GoRoute(
                name: RouterName.profileadmin,
                path: 'profileadmin',
                builder: (BuildContext context, GoRouterState state) {
                  return const Profileadmin();
                },

              ),
              //câp1
              GoRoute(
                name: RouterName.diadiem,
                path: 'diadiem',
                builder: (BuildContext context, GoRouterState state) {
                  return const DiaDiemPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: RouterName.detaildiadiem,
                    path: 'detaildiadiem',
                    builder: (BuildContext context, GoRouterState state) {
                      Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                      return DetailDiaDiemPage(
                        item: item,
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
                  return  DichBenhPage();
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
        ],
      ),

      ShellRoute(
        builder: (context, state, child) {
          return RootPage2(
            child: child,
          );
        },
        routes: [
          GoRoute(
            name: RouterName.home2,
            path: '/home2',
            builder: (BuildContext context, GoRouterState state) {
              return  const Home2Page();
            },//gốc
            //cấp1
            routes: <RouteBase>[
              GoRoute(
                name: RouterName.vegetable2,
                path: 'vegetable2',
                builder: (BuildContext context, GoRouterState state) {
                  return VegetablePage();
                },
                //cấp 2
                routes: <RouteBase>[
                  GoRoute(
                    name: RouterName.detailvegetable2,
                    path: 'detailvegetable2',
                    builder: (BuildContext context, GoRouterState state) {
                      Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                        return DetailVegetablePage(
                          item: item,
                        );
                    },
                  ),
                  GoRoute(
                    name: RouterName.addvegetable2,
                    path: 'addvegetable2',
                    builder: (BuildContext context, GoRouterState state) {
                      return AddVegetable();
                    },
                  ),
                ],

              ),
              GoRoute(
                name: RouterName.profile2,
                path: 'profile2',
                builder: (BuildContext context, GoRouterState state) {
                  return Profile();
                },

              ),
              //cấp 1
              GoRoute(
                name: RouterName.profileadmin2,
                path: 'profileadmin2',
                builder: (BuildContext context, GoRouterState state) {
                  return const Profileadmin2();
                },

              ),
              //câp1

              //câp 1
              GoRoute(
                name: RouterName.dichbenh2,
                path: 'dichbenh2',
                builder: (BuildContext context, GoRouterState state) {
                  return DichBenhPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: RouterName.detaildichbenh2,
                    path: 'detaildichbenh2',
                    builder: (BuildContext context, GoRouterState state) {
                      Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                      return DetailDichBenhPage(item: item);
                    },
                  ),
                  GoRoute(
                    name: RouterName.adddichbenh2,
                    path: 'adddichbenh2',
                    builder: (BuildContext context, GoRouterState state) {
                      return AddDichBenh();
                    },
                  ),
                ],
              ),

            ],
          ),
        ],
      ),

    ],
  );
}
