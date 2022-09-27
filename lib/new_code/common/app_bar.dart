import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/new_code/configurable.dart';

AppBar CustomAppBar(String title) => AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          //fontFamily: defaultFont,
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: Builder(
        builder: (context) => InkWell(
          onTap: () => Future.delayed(Duration.zero, () => Navigator.of(context).pop()),
          child:const Icon(Icons.arrow_back_ios,color: Colors.grey,)
        ),
      ),
    );

class _MenuButton extends StatelessWidget {
  final String iconPath;
  const _MenuButton({Key? key, required this.iconPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: Center(
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5.0),
                blurRadius: 15.0,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 16.0,
              height: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
