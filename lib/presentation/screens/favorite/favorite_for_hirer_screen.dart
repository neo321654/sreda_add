import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/presentation/screens/favorite/favorite_model_screen.dart';
import '/presentation/screens/favorite/response_screen.dart';

import '../../widgets/segmented_control.dart';

class FavoriteForHirerScreen extends StatefulWidget {
  FavoriteForHirerScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteForHirerScreen> createState() => _FavoriteForHirerScreenState();
}

class _FavoriteForHirerScreenState extends State<FavoriteForHirerScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  var valueIndex = 0;
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Text(
                'Избранное'.tr(),
                style: TextStyle(
                  //fontFamily: 'GloryMedium',
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: SegmentedControl(
                selectedIndex: _selectedIndex ?? 0,
               title: '',
                items: [
                  'Объявления'.tr(),
                  'Модели'.tr(),

                ],
                valueIndex: (int) {
                  setState(() {
                    _selectedIndex = int;
                  });

                  if(_selectedIndex==0){
                    _pageController.jumpToPage(0);
                  }else{
                    _pageController.jumpToPage(1);
                  }
                },
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                      child: PageView(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          RespondScreen(),
                          FavoriteModelScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

