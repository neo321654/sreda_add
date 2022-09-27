import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/presentation/colors.dart' as color;

import '../../colors.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Настройки'.tr(),
            style: TextStyle(
              //fontFamily: 'Glory-TSI-Meduim.ttf',
              fontWeight: FontWeight.w600,
              fontSize: 21,
              color: blackPearlColor,
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.athensGrayColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: color.vikingColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/example_image.jpeg',
                    height: 60,
                    width: 60,
                    //fit: BoxFit.contain,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Test Test',
                      style: TextStyle(
                        color: color.vikingColor,
                        fontFamily: 'Glory-TSI-Meduim.ttf',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'email@email.com',
                      style: TextStyle(
                        color: color.silverChaliceColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.exit_to_app,
                    color: color.vikingColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
