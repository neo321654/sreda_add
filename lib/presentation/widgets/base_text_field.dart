import 'package:flutter/material.dart';
import '/presentation/colors.dart';

class BaseTextField extends StatelessWidget {
  BaseTextField(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.inputType,
      required this.textAlign,
      required this.controller,
      required this.isVisibleTitle})
      : super(key: key);
  final String title;
  final String hintText;
  final TextInputType inputType;
  final TextAlign textAlign;
  final bool isVisibleTitle;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: isVisibleTitle,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  //fontFamily: "GloryMedium",
                  color: grey),
            ),
          ),
        ),
        Visibility(
          visible: isVisibleTitle,
          child: SizedBox(
            height: 10,
          ),
        ),
        TextField(
          maxLines: 1,
          keyboardType: inputType,
          textAlign: textAlign,
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                color: grey
              ),
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: silverGrayColor,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: silverGrayColor,
                  width: 1.0,
                ),
              )),
        ),
      ],
    );
  }
}
