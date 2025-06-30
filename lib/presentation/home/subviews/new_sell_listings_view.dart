import 'package:flutter/material.dart';

class NewSellListingsView extends StatelessWidget {
  const NewSellListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Sell Listings')),
      body: Center(
        child: Text(
          'New Sell Listings Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
