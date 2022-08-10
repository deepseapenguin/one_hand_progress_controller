
## Flutter one hand progress controller

Progress controller widget that represent in quarter circle design for one handed usage. Support both hand. \
Currently is more in a demo version to show how it looks like, not very customizable, will update soon. \
Open an issue if you have any feature request.

## Features

Allow user to control the progress of a video, music, etc with only their thumb. Below is an working example.

https://user-images.githubusercontent.com/36293056/183841325-079da160-d2bb-4e16-b1b9-7c1f7c368513.mov

the button and the onTap event is customizable, it can work with any video player as long as it support seeking, pause, play, or any other feature you need, and technically it could work with things other than video as long as it is something that able to control the progress value by the user.

## Usage

Put the widget into a Stack widget, example:

```
Stack(
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
)

```
<img src="https://i.imgur.com/O0beUKI.jpeg" width="300">

full example can be found in `example` folder
