import 'package:flutter/material.dart';
import 'package:one_hand_progress_controller/one_hand_progress_controller.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  int position = 0;
  int lenght = 0;
  VideoPlayerController? _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        _controller!.addListener(() {
          setState(() {
            var value = _controller!.value;
            position = value.position.inMilliseconds;
            lenght = value.duration.inMilliseconds;
            isPlaying = value.isPlaying;
          });
        });
        setState(() {});
      });
  }

  ActionButton getActionButton(IconData icon, Function() onTap) {
    return ActionButton(
        radius: 150,
        onTap: onTap,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ));
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
          Center(
            child: _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Container(),
          ),
          OneHandProgressController(
            size: 250,
            width: 50,
            progress: lenght == 0 ? 0 : position / lenght,
            handSide: HandSide.left,
            actionButtons: [
              getActionButton(Icons.skip_previous, () => null),
              getActionButton(Icons.fast_rewind, () => null),
              getActionButton(isPlaying ? Icons.pause : Icons.play_arrow, () {
                if (isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              }),
              getActionButton(Icons.fast_forward, () => null),
              getActionButton(Icons.skip_next, () => null),
            ],
            onProgessChange: ((p) {
              setState(() {
                var duration = (lenght.toDouble() * p).toInt();
                _controller!.seekTo(Duration(milliseconds: duration));
              });
            }),
          ),
        ],
      ),
    );
  }
}
