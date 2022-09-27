import 'package:csc_picker/csc_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../new_code/common/app_bar.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var controller = TextEditingController();
  var searchString = "";

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(""),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: CSCPicker(
              layout: Layout.vertical,
              showCities: true,
              showStates: true,
              countrySearchPlaceholder: "Страна".tr(),
              stateSearchPlaceholder: "Регион".tr(),
              citySearchPlaceholder: "Город".tr(),
              countryDropdownLabel: "Страна".tr(),
              stateDropdownLabel: "Регион".tr(),
              cityDropdownLabel: "Город".tr(),
              dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),

              ///triggers once state selected in dropdown
              onStateChanged: (value) {
                setState(() {
                  ///store value in state variable
                  if (value != null) {
                    stateValue = value;
                  }
                });
              },
              onCountryChanged: (value) {
                setState(() {
                  ///store value in country variable
                  countryValue = value;
                });
              },

              ///triggers once city selected in dropdown
              onCityChanged: (value) {
                setState(() {
                  ///store value in city variable
                  if (value != null) {
                    cityValue = value;
                    Navigator.pop(context, cityValue);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
