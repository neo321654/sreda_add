import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/presentation/colors.dart';
import '/presentation/screens/favorite/favorite_for_hirer_screen.dart';

import 'favorite/favorites_for_model_screen.dart';
import 'home/home_screen.dart';
import 'models/models_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late bool isModelType;

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getBodyBottomBar(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final _children = snapshot.data;
            return Scaffold(
              body: _children![_currentIndex],
              bottomNavigationBar: SizedBox(
                height: 78,
                child: CustomNavigationBar(
                  onTap: onTabTapped,
                  isFloating: true,
                  backgroundColor: color_Nab,
                  strokeColor: vikingColor,
                  borderRadius:const Radius.circular(18),
                  currentIndex: _currentIndex,
                  items: [
                    CustomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/ic_tab_home.svg'),
                      selectedIcon: SvgPicture.asset('assets/images/ic_tab_home_selected.svg'),
                    ),
                    CustomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/ic_tab_search.svg'),
                      selectedIcon: SvgPicture.asset('assets/images/ic_tab_search_selected.svg'),
                    ),
                    CustomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/ic_tab_heart.svg'),
                      selectedIcon: SvgPicture.asset('assets/images/ic_tab_heart_selected.svg'),
                    ),
                    CustomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/ic_tab_profile.svg'),
                      selectedIcon: SvgPicture.asset('assets/images/ic_tab_profile_selected.svg'),
                    ),
                  ],
                ),
              ),
              // bottomNavigationBar: BottomNavigationBar(
              //   type: BottomNavigationBarType.fixed,
              //   onTap: onTabTapped,
              //   elevation: 5,
              //   showSelectedLabels: false,
              //   showUnselectedLabels: false,
              //   currentIndex: _currentIndex,
              //   items: [
              //     BottomNavigationBarItem(
              //         icon: SvgPicture.asset('assets/images/ic_tab_home.svg'),
              //         activeIcon: SvgPicture.asset('assets/images/ic_tab_home_selected.svg'),
              //         label: ""),
              //     BottomNavigationBarItem(
              //         icon: SvgPicture.asset('assets/images/ic_tab_search.svg'),
              //         activeIcon: SvgPicture.asset('assets/images/ic_tab_search_selected.svg'),
              //         label: ""),
              //     BottomNavigationBarItem(
              //         icon: SvgPicture.asset('assets/images/ic_tab_heart.svg'),
              //         activeIcon: SvgPicture.asset('assets/images/ic_tab_heart_selected.svg'),
              //         label: ""),
              //     BottomNavigationBarItem(
              //         icon: SvgPicture.asset('assets/images/ic_tab_profile.svg'),
              //         activeIcon: SvgPicture.asset('assets/images/ic_tab_profile_selected.svg'),
              //         label: ""),
              //   ],
              // ),
            );
          }
        });
  }

  Future<List<dynamic>> getBodyBottomBar() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('TYPE') == 'MODEL') {
      return [
        HomeScreen(),
        ModelsScreen(),
        FavoritesForModelScreen(),
        ProfileScreen(),
      ];
    } else {
      return [
        HomeScreen(),
        ModelsScreen(),
        FavoriteForHirerScreen(),
        ProfileScreen(),
      ];
    }
  }
}
