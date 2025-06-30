import 'package:flutter/material.dart';

class TrendingView extends StatelessWidget {
  const TrendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trending')),
      body: Center(
        child: Text('Trending Content', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
