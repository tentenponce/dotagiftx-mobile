// coverage: ignore-file

import 'package:dotagiftx_mobile/presentation/core/widgets/widget_size.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatefulWidget {
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;
  final bool? isDisabled;
  final bool? isLoading;

  const AppElevatedButton({
    required this.child,
    this.onPressed,
    this.icon,
    this.style,
    this.textStyle,
    this.isDisabled,
    this.isLoading,
    this.width,
    this.height,
    super.key,
  });

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton> {
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _buttonStyle(Theme.of(context).colorScheme);

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: widget.isLoading ?? false ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: SizedBox(
            width: _size.width,
            height: _size.height,
            child: ElevatedButton(
              onPressed: () {},
              style: buttonStyle,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: buttonStyle?.foregroundColor?.resolve({}),
                ),
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity:
              widget.isLoading == false || widget.isLoading == null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: WidgetSize(
            onChange: (size) => setState(() => _size = size),
            child:
                widget.isDisabled ?? widget.isLoading ?? false
                    ? SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: null,
                        child: widget.child,
                      ),
                    )
                    : SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () => widget.onPressed?.call(),
                        child: widget.child,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  ButtonStyle? _buttonStyle(ColorScheme colorScheme) {
    return widget.style ??
        ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: colorScheme.primary, width: 1),
          elevation: 0,
        );
  }
}
