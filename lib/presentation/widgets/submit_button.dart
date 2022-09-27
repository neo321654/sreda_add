import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? textButton;
  final Color? borderColor;
  final Color? textColor;

  SubmitButton({
    this.onTap,
    this.textButton,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: borderColor ?? Color(0xff6CC9E0),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              textButton ?? 'Применить'.tr(),
              style: TextStyle(
                color: textColor ?? Color(0xff6CC9E0),
                fontSize: 17.0,
               // fontFamily: 'GloryRegular',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isRed;
  final String text;

  CustomButton({
    this.onTap,
    this.isRed = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 30.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isRed == true ? Colors.red : Color(0xff6CC9E0),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Icon(
                isRed ? Icons.clear : Icons.check,
                color: isRed ? Colors.red : Color(0xff6CC9E0),
                size: 14,
              ),
              SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(
                  color: isRed == true ? Colors.red : Color(0xff6CC9E0),
                  fontSize: 14.0,
                  fontFamily: 'GloryRegular',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
