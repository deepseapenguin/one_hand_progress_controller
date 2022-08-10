import 'package:flutter/material.dart';
import 'package:one_hand_progress_controller/one_hand_progress_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Showcase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          OneHandProgressController(
            size: 250,
            width: 50,
            progress: progress,
            onProgessChange: (p) {
              setState(() {
                progress = p;
              });
            },
            actionButtons: [
              ActionButton(
                  radius: 150,
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
