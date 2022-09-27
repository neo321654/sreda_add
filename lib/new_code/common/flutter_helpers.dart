import 'package:flutter/material.dart';

void pushPage(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
