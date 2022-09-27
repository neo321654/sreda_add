import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/presentation/colors.dart';
import '/presentation/screens/announcement/announcement_screen.dart';
import '/presentation/screens/search/search_city_screen.dart';
import '/presentation/widgets/segmented_control.dart';
import '/presentation/widgets/submit_button.dart';

import '../../../new_code/common/app_bar.dart';
import '../filters/filter_screen_widgets.dart' as w;

class FilterModelsScreen extends StatefulWidget {
  String? city;
  int? type;
  int? gender;

  FilterModelsScreen({
    Key? key,
    required this.city,
    required this.type,
    required this.gender,
  }) : super(key: key);

  @override
  State<FilterModelsScreen> createState() => _FilterModelsScreenState();
}

class _FilterModelsScreenState extends State<FilterModelsScreen> {
  List<CategoryCard> items = [
    CategoryCard(title: 'Фотограф'.tr(), isSelected: false),
    CategoryCard(title: 'Модель'.tr(), isSelected: false),
    CategoryCard(title: 'Другое'.tr(), isSelected: false),
  ];
  bool showItems = false;
  var city = "";
  int? genderIndex;
  int? _selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    if (city.isEmpty) {
      city = widget.city ?? "";
    }
    genderIndex ??= widget.gender ?? 2;
    _selectedCategoryIndex ??= widget.type ?? 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar("Фильтр".tr()),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(height: 10),
          Text("Город".tr(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  //fontFamily: "GloryMedium",
                  color: grey)),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async => {
              city = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ),
              setState(() {
                city;
              })
            },
            child: Container(
              height: 45,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffffffff),
                border: Border.all(
                  color: silverGrayColor,
                  width: 0.5,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: city.isEmpty?Text('Введите ваш город',
                style: TextStyle(
                  color: grey,
                  fontSize: 16
                ),):Text(city),
              ),
            ),
          ),
          SizedBox(height: 25.0),
          SegmentedControl(
            selectedIndex: genderIndex ?? 0,
            title: 'Пол исполнителя'.tr(),
            items: [
              'Женщины'.tr(),
              'Мужчины'.tr(),
              'Все'.tr(),
            ],
            valueIndex: (int) {
              setState(() {
                genderIndex = int;
              });
            },
          ),
          SizedBox(height: 25.0),

          SegmentedControl(
            selectedIndex:  _selectedCategoryIndex?? 0,
            title: 'Кого вы ищете?'.tr(),
            items: [
              'Фотограф'.tr(),
              'Модель'.tr(),
              'Другое'.tr(),
            ],
            valueIndex: (int) {
              setState(() {
                _selectedCategoryIndex = int;
              });
            },
          ),
            Expanded(child: Container()),
            SubmitButton(
              onTap: () {
                var data = {"city": city, "type": _selectedCategoryIndex, "gender": genderIndex, "isFiltered": true};
                Navigator.pop(context, data);
              },
            ),
            const SizedBox(height: 40)
            ]),
        ),
      ),
    );
  }

  int? getGender(int genderIndex) {
    if (genderIndex == 0 || genderIndex == 1) {
      genderIndex;
    } else {
      null;
    }
  }
}
