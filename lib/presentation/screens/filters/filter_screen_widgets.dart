import 'dart:math' as math;
import 'dart:ui' as dart_ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FilterCategories extends StatelessWidget {
  final int selectedCategoryIndex;
  final void Function(int) onSelect;

  FilterCategories({
    required this.selectedCategoryIndex,
    required this.onSelect,
  });

  final List<String> _categories = [
    'Фотограф'.tr(),
    'Модель'.tr(),
    'Другое'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: _categories.map(
          (e) {
            return LabeledRadioButtonItem(
              isSelected: _categories.indexOf(e) == selectedCategoryIndex,
              title: e,
              onTap: () => onSelect(
                _categories.indexOf(e),
              ),
            );
          },
        ).toList());
  }
}

class Slider extends StatefulWidget {
  final ValueChanged<List<double>>? valueChanged;
  final double? fromPrice;
  final double? toPrice;

  Slider({
    Key? key,
    this.valueChanged,
    this.fromPrice,
    this.toPrice,
  }) : super(key: key);

  @override
  SliderState createState() {
    return SliderState();
  }
}

class SliderState extends State<Slider> {
  double _firstX = 0;
  double _secondX = 500000;

  @override
  Widget build(BuildContext context) {
    // _firstX = widget.fromPrice ?? 0;
    // _secondX = widget.toPrice ?? 500000;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        rangeThumbShape: _Thumb(),
        rangeTrackShape: _Track(),
      ),
      child: RangeSlider(
        max: 1000000.0,
        min: 0.0,
        values: RangeValues(_firstX, _secondX),
        activeColor: Color(0xff6CC9E0),
        inactiveColor: Color(0xffEEEEEE),
        onChanged: (rangeValues) {
          setState(() {
            _firstX = rangeValues.start;
            _secondX = rangeValues.end;
          });

          widget.valueChanged?.call([_firstX, _secondX]);
        },
      ),
    );
  }
}

class _Thumb extends RangeSliderThumbShape {
  _Thumb({
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? 7.5 : 5.0);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    dart_ui.TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: 5.0,
      end: 7.5,
    );

    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final double radius = radiusTween.evaluate(enableAnimation);
    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop == true) {
      final Paint strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor!
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final Color color = colorTween.evaluate(enableAnimation)!;

    final double evaluatedElevation = isPressed! ? elevationTween.evaluate(activationAnimation) : elevation;
    final Path shadowPath = Path()
      ..addArc(
          Rect.fromCenter(
            center: center,
            width: 2 * radius,
            height: 2 * radius,
          ),
          0,
          math.pi * 2);
    canvas.drawShadow(shadowPath, Colors.black, evaluatedElevation, true);
    canvas.drawCircle(
      center,
      radius + 4.0,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
  }
}

class _Track extends RoundedRectRangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double overlayWidth = sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = overlayWidth / 4;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight = trackLeft * 3 + parentBox.size.width - overlayWidth;
    final double trackBottom = trackTop + trackHeight;
    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop, math.max(trackLeft, trackRight), trackBottom);
  }
}

class LabeledRadioButtonItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  LabeledRadioButtonItem({
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 67,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: isSelected ? Colors.white : Color(0xffFCFCFC),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        offset: Offset(0, 12.5),
                        blurRadius: 28.0,
                        color: Colors.black.withOpacity(0.1),
                      )
                    ]
                  : [],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff6CC9E0),
                        fontSize: 14.0,
                        fontFamily: 'GloryRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  AppRadioButton(
                    isSelected: isSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppRadioButton extends StatelessWidget {
  final bool isSelected;
  AppRadioButton({
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Color(0xff6CC9E0) : Color(0xffAAAAAA),
        ),
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Color(0xff6CC9E0)),
              ),
            )
          : SizedBox(),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final bool isSelected;
  final String path;

  _BottomBarItem({
    this.isSelected = false,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: 24.0,
      height: 24.0,
      color: isSelected ? Color(0xff6CC9E0) : Color(0xff1B877E).withOpacity(0.5),
    );
  }
}
