import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BlueButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String? textButton;
  final Color? colorButton;
  final Color? colorText;
  final double? sizeButton;
  final double? sizeTextButton;

 const BlueButton({Key? key,this.sizeTextButton=18.0,this.sizeButton=45.0, this.onTap, this.textButton, this.colorButton=const Color(0xff6CC9E0), this.colorText=Colors.white}) : super(key: key);

  @override
  State<BlueButton> createState() => _BlueButtonState();
}

class _BlueButtonState extends State<BlueButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.only(left: 5,right: 5),
          height: widget.sizeButton,
          decoration: BoxDecoration(
            color: widget.colorButton,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              widget.textButton ?? 'Отменить отклик'.tr(),
              style: TextStyle(
                color: widget.colorText,
                fontSize: widget.sizeTextButton,
                //fontFamily: 'GloryMedium',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
