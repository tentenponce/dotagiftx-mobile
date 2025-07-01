import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/new_buy_orders_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/new_sell_listings_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/trending_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget with ViewCubitMixin<HomeCubit> {
  const HomeView({super.key});

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

class _HomeViewState extends State<_HomeView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TrendingView(),
    const TreasuresView(),
    const HeroesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up),
            label: I18n.of(context).homeTrending,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: I18n.of(context).homeTreasures,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.sell),
            label: I18n.of(context).homeHeroes,
          ),
        ],
      ),
    );
  }
}
