library touch_indicator;

import 'package:flutter/material.dart';

/// Adds touch indicators to the screen whenever a touch occurs
/// 
/// This can be useful when recording videos of an app where you want to show 
/// where the user has tapped. Can also be useful when running integration 
/// tests or when giving demos with a screencast.
class TouchIndicator extends StatefulWidget {
  /// The child on which to show indicators
  final Widget child;

  /// The size of the indicator
  final double indicatorSize;

  /// The color of the indicator
  final Color indicatorColor;

  /// Overrides the default indicator. 
  /// 
  /// Make sure to set the proper [indicatorSize] to align the widget properly
  final Widget indicator;

  const TouchIndicator({
    Key key,
    @required this.child,
    this.indicator,
    this.indicatorSize = 40.0,
    this.indicatorColor = Colors.blueGrey,
  }) : super(key: key);

  @override
  _TouchIndicatorState createState() => _TouchIndicatorState();
}

class _TouchIndicatorState extends State<TouchIndicator> {
  Map<int, Offset> touchPositions = Map<int, Offset>();

  Iterable<Widget> buildTouchIndicators() sync* {
    if (touchPositions != null && touchPositions.length > 0) {
      for (var touchPosition in touchPositions.values) {
        yield Positioned.directional(
          start: touchPosition.dx - widget.indicatorSize / 2,
          top: touchPosition.dy - widget.indicatorSize / 2,
          child: widget.indicator != null
              ? widget.indicator
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.indicatorColor.withOpacity(0.3),
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    size: widget.indicatorSize,
                    color: widget.indicatorColor.withOpacity(0.9),
                  ),
                ),
          textDirection: TextDirection.ltr,
        );
      }
    }
  }

  void savePointerPosition(int index, Offset position) {
    setState(() {
      touchPositions[index] = position;
    });
  }

  void clearPointerPosition(int index) {
    setState(() {
      touchPositions.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      widget.child,
    ];
    children.addAll(buildTouchIndicators());
    return Listener(
      onPointerMove: (opm) {
        savePointerPosition(opm.pointer, opm.position);
      },
      onPointerCancel: (opc) {
        clearPointerPosition(opc.pointer);
      },
      onPointerUp: (opc) {
        clearPointerPosition(opc.pointer);
      },
      child: Stack(children: children),
    );
  }
}