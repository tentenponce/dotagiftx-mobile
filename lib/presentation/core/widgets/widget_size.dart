import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidgetSize extends StatefulWidget {
  final Widget child;
  final void Function(Size) onChange;

  const WidgetSize({required this.onChange, required this.child, super.key});

  @override
  WidgetSizeState createState() => WidgetSizeState();
}

class WidgetSizeState extends State<WidgetSize> {
  final GlobalKey<State<StatefulWidget>> _widgetKey = GlobalKey();
  Size? oldSize;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

    return Container(key: _widgetKey, child: widget.child);
  }

  Future<void> postFrameCallback(_) async {
    final context = _widgetKey.currentContext;

    await Future.delayed(
      const Duration(milliseconds: 100),
      () {},
    ); // wait till the widget is drawn

    if (!mounted || context == null) {
      return; // not yet attached to layout
    }

    // ignore: use_build_context_synchronously
    final newSize = context.size!;
    if (oldSize == newSize) {
      return;
    }

    oldSize = newSize;
    widget.onChange(newSize);
  }
}
