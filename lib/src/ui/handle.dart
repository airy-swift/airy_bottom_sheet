import 'package:airy_bottom_sheet/src/controller/airy_bottom_sheet_controller.dart';
import 'package:flutter/material.dart';

final class Handle extends StatelessWidget {
  const Handle({
    super.key,
    required this.controller,
    this.child = const _HandleBar(),
  });

  final AiryBottomSheetController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: controller.onDragStart,
      child: child,
    );
  }
}

final class _HandleBar extends StatelessWidget {
  const _HandleBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0x7F7F7F66),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0x7F7F7F66)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
