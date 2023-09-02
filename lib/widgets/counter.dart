library counter;

import 'package:fast/styles/color_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void CounterChangeCallback(num value);

class Counter extends StatelessWidget {
  final CounterChangeCallback onChanged;

  Counter({
    Key? key,
    required num initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    this.step = 1,
    this.buttonSize = 40,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  final num minValue;
  final num maxValue;
  final int decimalPlaces;
  num selectedValue;
  final num step;
  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: "COUNTERDECREMENT",
              onPressed: _decrementCounter,
              elevation: 2,
              backgroundColor: ClsColor.tipo1(),
              child: const Icon(Icons.remove, size: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text('${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}', style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700)),
          ),
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: "COUNTERINCREMENT",
              onPressed: _incrementCounter,
              elevation: 2,
              backgroundColor: ClsColor.tipo1(),
              child: const Icon(Icons.add, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
