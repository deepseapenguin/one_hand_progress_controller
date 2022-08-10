library one_hand_progress_controller;

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class ActionButton {
  final Function()? onTap;

  //define the distance from widget corner, if widget is set to left handside, it will be bottom left corner
  final double radius;
  final Icon icon;
  ActionButton({required this.radius, this.onTap, required this.icon});
}

enum HandSide { left, right }

class OneHandProgressController extends StatefulWidget {
  //widget size
  final double size;

  //touchable width of the progress bar
  final double width;
  final double progress;
  final Function(double)? onProgessChange;
  final List<ActionButton>? actionButtons;
  final Function()? onBackTap;
  final HandSide? handSide;
  const OneHandProgressController(
      {Key? key,
      required this.size,
      required this.width,
      required this.progress,
      this.onProgessChange,
      this.actionButtons,
      this.handSide,
      this.onBackTap})
      : super(key: key);

  @override
  State<OneHandProgressController> createState() =>
      _OneHandProgressControllerState();
}

class _OneHandProgressControllerState extends State<OneHandProgressController> {
  final GlobalKey containerKey = GlobalKey();

  bool progressDraging = false;
  double progressRad = 0;

  void progressChange(double dx, double dy) {
    RenderBox box =
        containerKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position

    double x = widget.handSide == HandSide.right
        ? position.dx + widget.size - dx
        : dx - position.dx;
    double y = (position.dy + widget.size) - dy;

    setState(() {
      progressRad = math.atan(y / x);
    });
  }

  void onDragEnd() {
    setState(() {
      progressDraging = false;
      var angleSpacing = 0.1;
      var startRad = angleSpacing;
      var totalRad = math.pi / 2 - angleSpacing * 2;
      var progress = (math.pi / 2 - progressRad - startRad) / totalRad;
      if (widget.handSide == HandSide.right) {
        progress = 1 - progress;
      }
      if (widget.onProgessChange != null) {
        widget.onProgessChange!(progress > 1
            ? 1
            : progress < 0
                ? 0
                : progress);
      }
    });
  }

  GestureDetector getProgressBarGestureDetector({required Widget child}) {
    return GestureDetector(
      onVerticalDragStart: (details) => setState(() {
        progressDraging = true;
      }),
      onVerticalDragEnd: (details) => onDragEnd(),
      onHorizontalDragStart: (details) => setState(() {
        progressDraging = true;
      }),
      onHorizontalDragEnd: (details) => onDragEnd(),
      onVerticalDragUpdate: (details) =>
          progressChange(details.globalPosition.dx, details.globalPosition.dy),
      onHorizontalDragUpdate: (details) =>
          progressChange(details.globalPosition.dx, details.globalPosition.dy),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var radius = widget.size - widget.width / 2;
    var angleSpacing = 0.1;
    var startRad = angleSpacing;
    var totalRad = math.pi / 2 - angleSpacing * 2;
    var endRad = startRad + totalRad;
    var rightHand = widget.handSide == HandSide.right;
    //determine the position of progress bar dot, prevent overflow
    var progressRad = this.progressRad < startRad
        ? startRad
        : this.progressRad > endRad
            ? endRad
            : this.progressRad;
    var currentRad = progressDraging
        ? progressRad
        : math.pi / 2 - (startRad + totalRad * widget.progress);

    if (!progressDraging && rightHand) {
      currentRad = math.pi / 2 - currentRad;
    }
    var x = radius * math.cos(currentRad);
    var y = radius * math.sin(currentRad);
    var progressDotSize = 15.0;
    var progressX = x - progressDotSize / 2;
    var progressY = y - progressDotSize / 2;

    var progressBarWidth = 5.0;

    var actionButtonsElement = [];
    if (widget.actionButtons != null) {
      var i = 0;
      for (var actionButton in widget.actionButtons!) {
        actionButtonsElement.add(ControlButton(
            radius: actionButton.radius,
            onTap: actionButton.onTap,
            total: widget.actionButtons!.length,
            position: i,
            handSide: widget.handSide,
            icon: actionButton.icon));
        i++;
      }
    }
    return Positioned(
        left: rightHand ? null : 0,
        right: rightHand ? 0 : null,
        bottom: 0,
        child: SizedBox(
          key: containerKey,
          height: widget.size,
          width: widget.size,
          child: Stack(
            children: [
              Material(
                shape: ControlShape(
                    leftSpacing: 0,
                    rightSpacing: 0,
                    size: widget.size,
                    handSide: widget.handSide,
                    strokeWidth: widget.size,
                    progress: 1),
                color: Colors.grey.shade900,
              ),
              SizedBox(
                height: widget.size,
                width: widget.size,
                child: getProgressBarGestureDetector(
                  child: Material(
                    shape: ControlShape(
                        leftSpacing: 0,
                        rightSpacing: 0,
                        size: widget.size,
                        handSide: widget.handSide,
                        strokeWidth: widget.width,
                        progress: 1),
                    color: Colors.black12,
                  ),
                ),
              ),
              Positioned(
                left: rightHand ? null : 0,
                right: rightHand ? 0 : null,
                bottom: 0,
                child: getProgressBarGestureDetector(
                  child: SizedBox(
                    width:
                        widget.size - widget.width / 2 + progressBarWidth / 2,
                    height:
                        widget.size - widget.width / 2 + progressBarWidth / 2,
                    child: Material(
                      shape: ControlShape(
                          leftSpacing: 0.1,
                          rightSpacing: 0.1,
                          handSide: widget.handSide,
                          size: widget.size -
                              widget.width / 2 +
                              progressBarWidth / 2,
                          strokeWidth: progressBarWidth,
                          progress: 1),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: rightHand ? null : 0,
                right: rightHand ? 0 : null,
                bottom: 0,
                child: getProgressBarGestureDetector(
                  child: SizedBox(
                    width:
                        widget.size - widget.width / 2 + progressBarWidth / 2,
                    height:
                        widget.size - widget.width / 2 + progressBarWidth / 2,
                    child: Material(
                      shape: ControlShape(
                          rightSpacing: 0.1,
                          leftSpacing: 0.1,
                          handSide: widget.handSide,
                          size: widget.size -
                              widget.width / 2 +
                              progressBarWidth / 2,
                          strokeWidth: progressBarWidth,
                          progress: widget.progress),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: rightHand ? null : progressX,
                  right: rightHand ? progressX : null,
                  bottom: progressY,
                  child: getProgressBarGestureDetector(
                      child: Container(
                          height: progressDotSize,
                          width: progressDotSize,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(progressDotSize),
                            color: Colors.white,
                          )))),
              ...actionButtonsElement,
              Positioned(
                left: rightHand ? null : 20,
                right: rightHand ? 20 : null,
                bottom: 20,
                child: Transform.rotate(
                  angle: rightHand ? -math.pi / 4 * 3 : -math.pi / 4,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: widget.onBackTap,
                    splashColor: Colors.white,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class ControlButton extends StatelessWidget {
  final double radius;
  final int total;
  final int position;
  final Icon icon;
  final HandSide? handSide;
  final Function()? onTap;

  const ControlButton(
      {Key? key,
      required this.radius,
      required this.total,
      required this.position,
      this.onTap,
      required this.icon,
      this.handSide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rightHand = handSide == HandSide.right;
    var split = total * 2;
    var pos = rightHand ? position * 2 + 1 : (split - (position * 2 + 1));
    var rad = pos * (math.pi / 2 / split);
    var x = (radius) * math.cos(rad);
    var rotate = math.pi / 2 - rad;
    var radMultiplier = (rightHand ? -1 : 1);
    return Positioned(
      left: rightHand ? null : x,
      right: rightHand ? x : null,
      bottom: radius * math.sin(rad),
      child: Transform.rotate(
        angle: rotate * radMultiplier,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          splashColor: Colors.white,
          child: icon,
        ),
      ),
    );
  }
}

class ControlShape extends ShapeBorder {
  final double size;
  final double strokeWidth;
  final double progress;
  final double leftSpacing;
  final double rightSpacing;
  final HandSide? handSide;
  const ControlShape(
      {required this.size,
      required this.strokeWidth,
      required this.progress,
      required this.leftSpacing,
      required this.rightSpacing,
      this.handSide});

  @override
  void paint(Canvas canvas, Rect rect, {ui.TextDirection? textDirection}) {
    return;
  }

  @override
  Path getOuterPath(Rect rect, {ui.TextDirection? textDirection}) {
    var inner = size - strokeWidth;
    var rightHand = handSide == HandSide.right;
    var extraXPos = rightHand ? size : 0.0;
    var rect = Rect.fromLTRB(-size + extraXPos, 0, size + extraXPos, size * 2);
    var baseRad = rightHand ? -math.pi : -math.pi / 2;
    var startAngle = baseRad + leftSpacing;
    var sweepAngle = (math.pi / 2 - leftSpacing - rightSpacing) * progress;
    return Path.combine(
        PathOperation.difference,
        Path()
          ..addArc(rect, startAngle, sweepAngle)
          ..lineTo(extraXPos, size),
        Path()
          ..addArc(
              Rect.fromLTRB(-inner + extraXPos, strokeWidth, inner + extraXPos,
                  inner * 2 + strokeWidth),
              startAngle,
              sweepAngle)
          ..lineTo(extraXPos, size));
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  ShapeBorder scale(double t) => ControlShape(
      size: size,
      strokeWidth: strokeWidth,
      progress: progress,
      leftSpacing: leftSpacing,
      rightSpacing: rightSpacing,
      handSide: handSide);
}
