import 'package:flutter/material.dart';
import '/presentation/colors.dart';

class BlueButton extends StatelessWidget {
  BlueButton({Key? key, required this.onPressed, required this.textButton}) : super(key: key);
  final GestureTapCallback onPressed;
  final String textButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // <-- Your width
      height: 45, // <-- Your height
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(textButton),
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,
                //fontFamily: 'GloryMedium',
                fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // <-- Radius
            ),
            primary: vikingColor),
      ),
    );
  }
}
