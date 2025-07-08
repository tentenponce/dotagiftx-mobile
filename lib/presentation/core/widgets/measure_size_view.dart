import 'package:flutter/widgets.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeView extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onChange;

  const MeasureSizeView({
    required this.onChange,
    required this.child,
    super.key,
  });

  @override
  State<MeasureSizeView> createState() => _MeasureSizeViewState();
}

class _MeasureSizeViewState extends State<MeasureSizeView> {
  final _key = GlobalKey();
  Size? oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return Container(key: _key, child: widget.child);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    super.initState();
  }

  void _notifySize() {
    final context = _key.currentContext;
    if (context == null) {
      return;
    }

    final newSize = context.size;
    if (oldSize == newSize || newSize == null) {
      return;
    }

    oldSize = newSize;
    widget.onChange(newSize);
  }
}
