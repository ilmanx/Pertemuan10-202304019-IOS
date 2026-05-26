// lib/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca state keranjang yang terus di-pantau perubahannya
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),

      body: Column(
        children: [
          // Bagian atas: Daftar barang
          Expanded(
            child:
                cart.items.isEmpty
                    ? const Center(child: Text('Keranjang Anda kosong.'))
                    : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        // Mengambil data dari map dengan index
                        final cartItem = cart.items.values.toList()[index];
                        final productId = cart.items.keys.toList()[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          child: ListTile(
                            title: Text(cartItem.product.name),

                            subtitle: Text(
                              'Harga: \$${cartItem.product.price} x ${cartItem.quantity}',
                            ),

                            // Bagian kanan: Tombol + dan - untuk manajemen kuantitas
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                  ),

                                  onPressed: () {
                                    context
                                        .read<CartProvider>()
                                        .decrementQuantity(productId);
                                  },
                                ),

                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                  ),

                                  onPressed: () {
                                    context
                                        .read<CartProvider>()
                                        .addToCart(cartItem.product);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),

          // Bagian bawah: Total Harga dan Tombol Checkout
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Total Harga:',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),

                  onPressed:
                      cart.items.isEmpty
                          ? null // Tombol mati jika keranjang kosong
                          : () {
                            // Simulasi proses checkout
                            context.read<CartProvider>().clearCart();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Checkout Berhasil! Terima Kasih.',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Kembali ke halaman sebelumnya (daftar produk)
                            Navigator.pop(context);
                          },

                  child: const Text(
                    'CHECKOUT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}