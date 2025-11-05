import 'package:dotagiftx_mobile/core/logging/navigation_logger.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/presentation/app/models/app_state.dart';
import 'package:dotagiftx_mobile/presentation/app/viewmodels/app_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/theme_ext.dart';
import 'package:dotagiftx_mobile/presentation/home/home_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class App extends StatelessWidget with ViewCubitMixin<AppCubit> {
  const App({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _App();
  }
}

class _App extends StatefulWidget {
  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  final NavigationLogger _navigationLogger = getIt<NavigationLogger>();

  @override
  Widget build(BuildContext context) {
    const initialPage = HomeView();

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen:
            (previous, current) =>
                previous.seedColor != current.seedColor ||
                previous.brightness != current.brightness,
        builder: (context, state) {
          final seedColor = state.seedColor?.toColor() ?? AppColors.primary;
          const brightness = Brightness.dark;

          return MaterialApp(
            navigatorObservers: [_navigationLogger],
            navigatorKey: GetIt.instance<GlobalKey<NavigatorState>>(),
            localizationsDelegates: const [
              I18n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: I18n.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: seedColor,
                brightness: brightness,
                primary: seedColor,
              ),
              useMaterial3: true,
            ),
            onGenerateRoute:
                (settings) => null, // to trigger onGenerateInitialRoutes
            onGenerateInitialRoutes:
                (_) => [
                  MaterialPageRoute(
                    settings: NavigatorUtils.buildRouteSettings(initialPage),
                    builder: (_) => initialPage,
                  ),
                ],
          );
        },
      ),
    );
  }
}
