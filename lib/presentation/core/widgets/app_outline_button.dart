// coverage: ignore-file

import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/widget_size.dart';
import 'package:flutter/material.dart';

class AppOutlineButton extends StatefulWidget {
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;
  final bool? isDisabled;
  final bool? isLoading;

  const AppOutlineButton({
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
  State<AppOutlineButton> createState() => _AppOutlineButtonState();
}

class _AppOutlineButtonState extends State<AppOutlineButton> {
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: widget.isLoading ?? false ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: SizedBox(
            width: _size.width,
            height: _size.height,
            child: OutlinedButton(
              onPressed: () {},
              style: _buttonStyle(),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
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
                      child: OutlinedButton(
                        style: _buttonStyle(),
                        onPressed: null,
                        child: widget.child,
                      ),
                    )
                    : SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: OutlinedButton(
                        style: _buttonStyle(),
                        onPressed: () => widget.onPressed?.call(),
                        child: widget.child,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  ButtonStyle? _buttonStyle() {
    return widget.style ??
        OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColors.primary, width: 1),
          elevation: 0,
        );
  }
}
