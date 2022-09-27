import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/presentation/colors.dart';

class EmailField extends StatelessWidget {
  const EmailField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
       const SizedBox(
          height: 25,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "E-mail".tr(),
            textAlign: TextAlign.center,
            style:const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: "GloryMedium", color: Colors.grey),
          ),
        ),
       const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 45,
          child: TextField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.start,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Введите ваш e-mail',
                hintStyle:const TextStyle(color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                contentPadding:const EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:const BorderSide(
                    color: silverGrayColor,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:const BorderSide(
                    color: silverGrayColor,
                    width: 1.5,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
