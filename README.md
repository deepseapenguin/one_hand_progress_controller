
## Flutter one hand progress controller

Progress controller widget that represent in quarter circle design for one handed usage. \
Currently is more in a demo version to show how it looks like, not very customizable, will update soon. \
Open an issue if you have any feature request.

## Features

Allow user to control the progress of a video, music, etc with only their thumb. Below is an working example.

https://i.imgur.com/n9TwtMu.mp4

the button and the onTap event is customizable, it can work with any video player as long as it support seeking, pause, play, or any other feature you need, and technically it could work with things other than video as long as it is something that able to control the progress value by the user.

## Usage

Put the widget into a Stack widget, example:

```
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          OneHandProgressController(
            size: 250,
            width: 50,
            progress: progress,
            onProgessChange: ((p) {
              setState(() {
                progress = p;
              });
            }),
            actionButtons: [
              ActionButton(
                  radius: 150,
                  onTap: () {},
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

```

![Basic example](https://i.imgur.com/O0beUKI.jpeg)

