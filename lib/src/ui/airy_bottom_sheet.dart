import 'package:airy_bottom_sheet/airy_bottom_sheet.dart';
import 'package:airy_bottom_sheet/src/ui/front_swticher.dart';
import 'package:flutter/material.dart';

final class AiryBottomSheet<T> extends StatefulWidget {
  const AiryBottomSheet._({
    required this.controller,
    required this.handle,
    required this.borderRadius,
    required this.elevation,
    required this.backgroundColor,
    required this.dragUpdateDuration,
    required this.onDragAndAnimationEnd,
    required this.dragEndDuration,
    required this.switchChildren,
  });

  static Future<void> show(
    GlobalKey<ScaffoldState> scaffoldKey, {
    required AiryBottomSheetController controller,
    Widget handle = const SizedBox.shrink(),
    BorderRadius borderRadius = const BorderRadius.vertical(top: Radius.circular(12)),
    double elevation = 10,
    void Function(double)? onDragAndAnimationEnd,
    Color backgroundColor = Colors.white,
    bool awaitClose = true,
    Duration dragUpdateDuration = const Duration(milliseconds: 30),
    Duration dragEndDuration = const Duration(milliseconds: 100),
    required List<Widget> switchChildren,
  }) async {
    final ref = scaffoldKey.currentState?.showBottomSheet(
      (BuildContext context) => AiryBottomSheet._(
        controller: controller,
        handle: handle,
        borderRadius: borderRadius,
        elevation: elevation,
        backgroundColor: backgroundColor,
        onDragAndAnimationEnd: onDragAndAnimationEnd,
        dragUpdateDuration: dragUpdateDuration,
        dragEndDuration: dragEndDuration,
        switchChildren: switchChildren,
      ),
      enableDrag: false,
    );

    if (awaitClose) {
      await ref?.closed;
      final context = scaffoldKey.currentState?.context;
      if (context != null) {
        Navigator.of(context).pop();
      }
    }
  }

  final AiryBottomSheetController controller;

  final Widget handle;

  final BorderRadius borderRadius;

  final double elevation;

  final Color backgroundColor;

  final List<Widget> switchChildren;

  final void Function(double)? onDragAndAnimationEnd;

  final Duration dragEndDuration;
  final Duration dragUpdateDuration;

  @override
  State<AiryBottomSheet> createState() => _AiryBottomSheetState();
}

final class _AiryBottomSheetState extends State<AiryBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_notifyControllerValueChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_notifyControllerValueChange);
    super.dispose();
  }

  void _notifyControllerValueChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: widget.controller.onVerticalDragUpdate,
      onVerticalDragEnd: widget.controller.onVerticalDragEnd,
      child: PhysicalModel(
        elevation: widget.elevation,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: ColoredBox(
            color: widget.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: widget.controller.isDragging //
                      ? widget.dragUpdateDuration
                      : widget.dragEndDuration,
                  curve: Curves.easeInOut,
                  height: widget.controller.height,
                  onEnd: _onDragEnd,
                  child: FrontSwitcher(
                    frontSwitchData: widget.controller.value.frontSwitchData,
                    switchChildren: widget.switchChildren,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDragEnd() {
    if (widget.controller.isDragging) {
      return;
    }
    final onDragAndAnimationEnd = widget.onDragAndAnimationEnd;
    if (onDragAndAnimationEnd != null) {
      onDragAndAnimationEnd(widget.controller.height);
    }
  }
}
