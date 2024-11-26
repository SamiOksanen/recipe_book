import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterListener extends StatelessWidget {
  final Widget child;
  final void Function() onEnter;
  final FocusNode _focusNode = FocusNode(skipTraversal: true);

  EnterListener({super.key, required this.child, required this.onEnter});

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: false,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          onEnter();
        }
      },
      child: child,
    );
  }
}
