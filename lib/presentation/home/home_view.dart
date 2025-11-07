import 'dart:async';

import 'package:dotagiftx_mobile/core/platform/app_navigation_observer/app_navigation_observer.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/base/state_base.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/heroes_nav_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/home_nav_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/treasures_nav_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/profile/profile_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends BasePageStatelessWidget with ViewCubitMixin<HomeCubit> {
  const HomeView({super.key}) : super(pageName: PageName.home);

  @override
  Widget buildView(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends StateBase<_HomeView> {
  final _appNavigationObserver = getIt<AppNavigationObserver>();

  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => previous.user != current.user,
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;

                    // manually log to firebase analytics
                    final screenClass = _pages[index].runtimeType.toString();
                    var screenName = screenClass;

                    switch (_pages[index]) {
                      case HomeNavView():
                        screenName = 'nav-home';
                      case TreasuresNavView():
                        screenName = 'nav-treasures';
                      case HeroesNavView():
                        screenName = 'nav-heroes';
                      case ProfileView():
                        screenName = 'nav-profile';
                    }

                    _appNavigationObserver.logNavigation(
                      screenName: screenName,
                      screenClass: screenClass,
                    );
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                selectedItemColor: Theme.of(context).colorScheme.onSurface,
                unselectedItemColor: Theme.of(context).colorScheme.onSurface,
                selectedLabelStyle: AppTextStyles.defaultTextStyle(context),
                unselectedLabelStyle: AppTextStyles.defaultTextStyle(context),
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: I18n.of(context).homeHome,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.diamond_rounded),
                    label: I18n.of(context).homeTreasures,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.groups),
                    label: I18n.of(context).homeHeroes,
                  ),
                  BottomNavigationBarItem(
                    icon:
                        !StringUtils.isNullOrEmpty(state.user?.avatar)
                            ? DotagiftxImageView(
                              imageUrl: state.user!.avatar!,
                              width: 24,
                              height: 24,
                            )
                            : const Icon(Icons.account_circle),
                    label: I18n.of(context).homeProfile,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeNavView(),
      TreasuresNavView(onTreasureTap: _navigateToHomeWithSearch),
      HeroesNavView(onHeroTap: _navigateToHomeWithSearch),
      ProfileView(
        loginSuccess: _navigateToHome,
        logoutSuccess: _navigateToHome,
        showBackButton: false,
      ),
    ];
  }

  void _navigateToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _navigateToHomeWithSearch(String searchQuery) {
    // Navigate to home tab
    setState(() {
      _currentIndex = 0;
    });

    // Set search query in HomeCubit
    unawaited(context.read<HomeCubit>().searchCatalog(query: searchQuery));
  }
}
