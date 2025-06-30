import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:flutter/material.dart';

import 'subviews/new_buy_orders_view.dart';
import 'subviews/new_sell_listings_view.dart';
import 'subviews/trending_view.dart';

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
    const NewBuyOrdersView(),
    const NewSellListingsView(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'New Buy Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'New Sell Listings',
          ),
        ],
      ),
    );
  }
}
