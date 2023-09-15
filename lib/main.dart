import 'package:flutter/material.dart';
import 'dart:async';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Stopwatch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stopwatch _stopwatch;
  String _stopwatchText = '00:00:00';
  final int _milliLimit = 100;
  int _milli = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _startStopwatch();
  }

  void _startStopwatch() {
    Timer.periodic(Duration(milliseconds: _milliLimit), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _milli += timer.tick;
          final int seconds = (_milli / (_milliLimit / 10)).truncate();
          _stopwatchText =
          '${_printTime(seconds ~/ 3600)}:${_printTime((seconds % 3600) ~/ 60)}:${_printTime(seconds % 60)}';
        });
      }
    });
    _stopwatch.start();
  }

  String _printTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_stopwatchText',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _stopwatch.isRunning ? _stopwatch.stop() : _stopwatch.start()),
          tooltip: 'Toggle stopwatch',
          child: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
        ),
      ),
    );
  }
}