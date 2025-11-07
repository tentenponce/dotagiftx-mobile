import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  const HomeAppBar({
    required this.title,
    this.actions,
    this.leading,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // in android, dark is dark icons, light is light icons
        statusBarIconBrightness:
            Theme.of(context).colorScheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
        // in iOS it is inverted, light is dark icons, dark is light icons
        statusBarBrightness: Theme.of(context).colorScheme.brightness,
      ),
    );
  }
}
