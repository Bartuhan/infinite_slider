import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:infinite_slider/features/home/presentation/widgets/dragable_widget.dart';

class InfiniteDragableSlider extends StatefulWidget {
  const InfiniteDragableSlider({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.index = 0,
  });

  final Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final int index;

  @override
  State<InfiniteDragableSlider> createState() => _InfiniteDragableSliderState();
}

class _InfiniteDragableSliderState extends State<InfiniteDragableSlider> with SingleTickerProviderStateMixin {
  final defautAngle18Dgree = pi * 0.1;

  late AnimationController controller;
  late int index;

  SlideDirection slideDirection = SlideDirection.left;

  Offset getOffset(int stackIndex) {
    return {
          0: Offset(lerpDouble(0, -70, controller.value)!, 30),
          1: Offset(lerpDouble(-70, 70, controller.value)!, 30),
          2: const Offset(70, 30) * (1 - controller.value),
        }[stackIndex] ??
        Offset(
          MediaQuery.of(context).size.width * controller.value * (slideDirection == SlideDirection.left ? -1 : 1),
          0,
        );
  }

  double getAngle(int stackIndex) =>
      {
        0: lerpDouble(0, -defautAngle18Dgree, controller.value),
        1: lerpDouble(-defautAngle18Dgree, defautAngle18Dgree, controller.value),
        2: lerpDouble(defautAngle18Dgree, 0, controller.value),
      }[stackIndex] ??
      0.0;

  double getScale(int stackIndex) =>
      {
        0: lerpDouble(0.6, 0.9, controller.value),
        1: lerpDouble(0.9, 0.95, controller.value),
        2: lerpDouble(0.95, 1, controller.value),
      }[stackIndex] ??
      1.0;

  void onSlideOut(SlideDirection direction) {
    slideDirection = direction;
    controller.forward();
  }

  void animationListener() {
    if (controller.isCompleted) {
      setState(() {
        if (widget.itemCount == ++index) {
          index = 0;
        }
      });
      controller.reset();
    }
  }

  @override
  void initState() {
    index = widget.index;
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))..addListener(animationListener);
    super.initState();
  }

  @override
  void dispose() {
    controller
      ..removeListener(animationListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Stack(
              children: List.generate(4, (stackIndex) {
            final modIndex = (index + 3 - stackIndex) % widget.itemCount;
            return Transform.translate(
              offset: getOffset(stackIndex),
              child: Transform.scale(
                scale: getScale(stackIndex),
                child: Transform.rotate(
                  angle: getAngle(stackIndex),
                  child: DragableWidget(
                    onSlideOut: onSlideOut,
                    isEnableDrag: stackIndex == 3,
                    child: widget.itemBuilder(context, modIndex),
                  ),
                ),
              ),
            );
          }));
        });
  }
}
