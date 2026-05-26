// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cartProvider = CartProvider();

  await cartProvider.loadCart();

  runApp(
    ChangeNotifierProvider.value(
      value: cartProvider,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini E-Commerce',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: ProductListScreen(),
    );
  }
}