import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/presentation/colors.dart';
import '/presentation/screens/search/search_city_screen.dart';
import '/presentation/widgets/segmented_control.dart';
import '/presentation/widgets/submit_button.dart';

import '../../../new_code/common/app_bar.dart';
import 'filter_screen_widgets.dart' as w;

class FilterScreen extends StatefulWidget {
  final String? city;
  final int? workType;
  final int? gender;
  final int? fromPrice;
  final int? toPrice;
  final int? category;

  FilterScreen({
    Key? key,
    this.city,
    this.workType,
    this.gender,
    this.fromPrice,
    this.toPrice,
    this.category,
  }) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var city = "";
  int? genderIndex;
  int? categoryIndex;
  int? _selectedCategoryIndex;
  int? _fromPrice;
  int? _toPrice;
  bool isChanged = false;

  @override
  Widget build(BuildContext context) {
    if (city.isEmpty) {
      city = widget.city ?? "";
    }
    genderIndex ??= widget.gender ?? 2;
    categoryIndex ??= widget.category ?? 2;
    _selectedCategoryIndex ??= widget.workType ?? 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar("Фильтры".tr()),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           SizedBox(
             height: 10,
           ),
           Visibility(
             visible: true,
             child: SegmentedControl(
               selectedIndex: categoryIndex ?? 2,
               title: 'Тип работы'.tr(),
               items: [
                 'TFP'.tr(),
                 'С оплатой'.tr(),
                 'Все'.tr(),
               ],
               valueIndex: (int) {
                 setState(() {
                   categoryIndex = int;
                 });
               },
             ),
           ),
           SizedBox(height: 18.0),
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
           SizedBox(height: 18.0),
           SegmentedControl(
             selectedIndex:  _selectedCategoryIndex?? 0,
             title: 'Категория'.tr(),
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
           SizedBox(height: 20.0),
           Text(
             'Таблица цен'.tr(),
             style: TextStyle(
               //fontFamily: 'GloryRegular',
               color: grey,
               fontSize: 14.0,
               height: 18.0 / 16.0,
             ),
           ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
             child: Row(
               children: [
                 Expanded(
                   child: _PriceTextField(
                     label: "От".tr(),
                     onChanged: (newValue) => setState(() => _fromPrice = newValue),
                     initialValue: 0,
                   ),
                 ),
                 SizedBox(width: 10),
                 Expanded(
                   child: _PriceTextField(
                     label: "До".tr(),
                     onChanged: (newToPrice) => setState(() => _toPrice = newToPrice),
                     initialValue: null,
                   ),
                 ),
               ],
             ),
           ),
            Expanded(child: Container()),
            SubmitButton(
              onTap: () {
                var data = {
                  "city": city,
                  "workType": _selectedCategoryIndex,
                  "gender": genderIndex,
                  "category": _selectedCategoryIndex,
                  "fromPrice": _fromPrice,
                  "toPrice": _toPrice,
                  "isFiltered": true
                };
                Navigator.pop(context, data);
              },
            ),

          ],
            ),
        ),
      ),
    );
  }

  String getFromPrice() {
    if (isChanged) {
      return _fromPrice.toString();
    } else {
      return widget.fromPrice.toString();
    }
  }

  String getToPrice() {
    if (isChanged) {
      return _toPrice.toString();
    } else {
      return widget.toPrice.toString();
    }
  }
}

class _PriceTextField extends StatelessWidget {
  final String label;
  final int? initialValue;
  final Function(int) onChanged;
  const _PriceTextField({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: vikingColor, width: 2),
    );
    return TextFormField(
      initialValue: (initialValue ?? "").toString(),
      onChanged: (newValue) => onChanged(int.parse(newValue)),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: vikingColor,
      decoration: InputDecoration(
        fillColor: vikingColor,
        focusColor: vikingColor,
        hoverColor: vikingColor,
        labelStyle: TextStyle(color: vikingColor),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        label: Text(label),
      ),
    );
  }
}
