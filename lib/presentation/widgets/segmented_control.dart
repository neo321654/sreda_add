import 'package:flutter/material.dart';

import '../colors.dart';

class SegmentedControl extends StatefulWidget {
  final String title;
  final List<String> items;
  final int selectedIndex;
  final void Function(int)? onPressed;
  final Function(int) valueIndex;
  SegmentedControl({
    Key? key,
    required this.title,
    required this.items,
    required this.valueIndex,
    required this.selectedIndex,
    this.onPressed,
  }) : super(key: key);

  @override
  _SegmentedControlState createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  var _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.selectedIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: grey,
            //fontFamily: 'GloryRegular',
            fontSize: 14,
            height: 18.0 / 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(children: widget.items.map<Widget>((e) => _SegmentItem(
                    isSelected: widget.items[_selectedIndex] == e,
                    title: e,
                    lenght: widget.items.length,
                    index: widget.items.indexOf(e),
                    onTap: () => {
                      widget.valueIndex(widget.items.indexOf(e)),
                      setState(
                        () => _selectedIndex = widget.items.indexOf(e),
                      )
                    },
                  ))
              .toList()
         )
      ],
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final bool isSelected;
  final String title;
  final int index;
  final int lenght;
  final VoidCallback? onTap;

  _SegmentItem({
    Key? key,
    required this.lenght,
    required this.index,
    this.onTap,
    required this.isSelected,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(7.0),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 9.0,
            ),
            decoration: BoxDecoration(
              borderRadius: index==0?
              const BorderRadius.only(topLeft:Radius.circular(10.0),bottomLeft: Radius.circular(10.0)):index==2?
              const BorderRadius.only(topRight:Radius.circular(10.0),bottomRight:Radius.circular(10.0)):lenght>2?BorderRadius.circular(0):
              const BorderRadius.only(topRight:Radius.circular(10.0),bottomRight:Radius.circular(10.0)),
              color: isSelected ? Color(0xff6CC9E0) : Colors.white,
              border: Border.all(color: Color(0xff6CC9E0)),
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xff6CC9E0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension ListExt<T> on List<T> {
  List<T> joined(T element) {
    return _joinedIterable(element).toList();
  }

  Iterable<T> _joinedIterable(T element) sync* {
    for (int i = 0; i < length; i++) {
      yield this[i];

      if (i + 1 != length) {
        yield element;
      }
    }
  }
}
