import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double x; // X-coordinate of the FAB
  final double y; // Y-coordinate of the FAB

  CustomFloatingActionButtonLocation(this.x, this.y);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Return the offset based on the provided x and y coordinates
    return Offset(x, y);
  }
}
