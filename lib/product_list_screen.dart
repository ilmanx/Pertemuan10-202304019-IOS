// lib/product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'cart_provider.dart';
import 'cart_screen.dart'; // Akan kita buat di langkah selanjutnya

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  // Dummy data daftar produk yang dijual
  final List<Product> _products = [
    Product(id: 'p1', name: 'Laptop Pro X', price: 15000.0),
    Product(id: 'p2', name: 'Smartphone Z', price: 8000.0),
    Product(id: 'p3', name: 'Wireless Mouse', price: 250.0),
    Product(id: 'p4', name: 'Mechanical Keyboard', price: 1200.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce Mini'),
        actions: [
          // Ikon keranjang di pojok kanan atas dengan indikator jumlah barang
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigasi ke halaman keranjang
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),

                  // Menggunakan watch untuk mendengarkan perubahan jumlah item
                  child: Text(
                    '${context.watch<CartProvider>().itemCount}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // Menampilkan daftar produk dalam bentuk ListView
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];

          return ListTile(
            leading: const Icon(Icons.devices, size: 40),
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),

            trailing: ElevatedButton(
              onPressed: () {
                // Menggunakan read karena kita hanya memicu aksi, tidak butuh render ulang
                context.read<CartProvider>().addToCart(product);

                // Menampilkan notifikasi kecil di bawah layar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${product.name} ditambahkan ke keranjang!',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Add'),
            ),
          );
        },
      ),
    );
  }
}