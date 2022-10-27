import 'package:flutter/cupertino.dart';

extension Config on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}
