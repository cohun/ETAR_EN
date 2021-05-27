import 'package:flutter/material.dart';

class LifeCycle extends StatefulWidget {
  final Widget child;

  const LifeCycle({@required this.child});

  @override
  _LifeCycleState createState() => _LifeCycleState();
}

class _LifeCycleState extends State<LifeCycle> with WidgetsBindingObserver {
  DateTime _startTime;
  DateTime _endTime;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    _endTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _reportData(DateTime.now().difference(_startTime));
        _endTime = DateTime.now();
        return;
      case AppLifecycleState.resumed:
        _startTime = DateTime.now();
        return;
      default:
        return;
    }
  }
}

void _reportData(Duration time) {
  print("used app for ${time.inSeconds} seconds");
  if (time.inSeconds > 20) print('hello');
  // If time is greater than 8 hrs set company to start
}
