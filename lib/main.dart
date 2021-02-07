import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _top = 0;
  double _topStep = 50;
  double _vertAngle = 50;
  double _left = 0;
  double _leftStep = 50;

  bool _down = true;
  bool _right = true;

  double _hgt ;
  double _wdt;


  Size _boxSize = Size(150, 150);

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        if (_animationController.status == AnimationStatus.completed) {
          _updatePos();
          _animationController
            ..reset()
            ..forward();
        }
      })
      ..forward();
  }

  void _updatePos() {
    var rand = Random();
    setState(() {
      _top += _topStep;
      _topStep = _vertAngle * (_down ? 1 : -1);
      if (_down && _top + _topStep >= (_hgt)) {
        // _top = _hgt;
        // _topStep = (_hgt) - (_top + 15);
        _down = false;
        _vertAngle = (rand.nextDouble() * 40) + 10;
      } else if (!_down && _top + _topStep <= 0) {
        // _top = 0;
        // _topStep = -_top;
        _down = true;
        _vertAngle = (rand.nextDouble() * 40) + 10;
      }

      _left += _leftStep;
      _leftStep = 25.0 * (_right ? 1 : -1);
      if (_right && (_left + _leftStep) > _wdt) {
        // _left = 0;
        _right = false;
      } else if (!_right && _left + _leftStep <= 0) {
        _right = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _hgt = MediaQuery.of(context).size.height;
    _wdt = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.black12,
        width: _wdt,
        height: _hgt,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            Animation<double> _topAnimation =
                Tween<double>(begin: _top, end: _top + _topStep)
                    .animate(_animationController);

            Animation<double> _leftAnimation =
                Tween<double>(begin: _left, end: _left + _leftStep)
                    .animate(_animationController);

            return Stack(
              children: [
                Positioned(
                  top: _topAnimation.value.clamp(0, _hgt - _boxSize.width),
                  left: _leftAnimation.value.clamp(0, _wdt - _boxSize.height),
                  width: _boxSize.width,
                  height: _boxSize.height,
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(style: BorderStyle.none,),
                      borderRadius: BorderRadius.circular(90),
                      color: Colors.blue
                    ),
                  ),
                ),
                // Positioned(
                //   top: _topAnimation.value.clamp(0, _hgt - 15),
                //   left: _leftAnimation.value.clamp(0, _wdt - 15),
                //   width: 15,
                //   height: 15,
                //   child: Container(
                //     color: Colors.red,
                //   ),
                // )
              ],
            );
          },
        ),
      ),
    );
  }
}
