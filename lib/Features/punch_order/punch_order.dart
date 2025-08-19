import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motives_tneww/Features/punch_order/cart_screen.dart';
import 'package:motives_tneww/Models/product_model.dart';

import 'package:flutter/material.dart';
import 'package:motives_tneww/screens/dashboard.dart';
import 'package:motives_tneww/theme_change/theme_bloc.dart';


import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';



class PunchOrderView extends StatefulWidget {
  const PunchOrderView({super.key});
  @override
  State<PunchOrderView> createState() => _PunchOrderViewState();
}

class _PunchOrderViewState extends State<PunchOrderView> {
  final List<Product> _products = [
    Product(title: 'Mezan Hardum', sku: 'SKU001', imageUrl: 'assets/product1.jfif', price: 29.99),
    Product(title: 'Mezan Ultra Rich', sku: 'SKU002', imageUrl: 'assets/product2.jfif', price: 49.99),
    Product(title: 'Mezan Danedar', sku: 'SKU003', imageUrl: 'assets/product3.jfif', price: 19.99),
    Product(title: 'Hardum Mixture', sku: 'SKU004', imageUrl: 'assets/product4.jfif', price: 39.99),
    Product(title: 'Hardum Mix 5', sku: 'SKU005', imageUrl: 'assets/product5.jfif', price: 39.99),
    Product(title: 'Hardum Mix 6', sku: 'SKU006', imageUrl: 'assets/product6.jfif', price: 39.99),
  ];

  // map sku -> quantity (keeps UI in sync)
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _reloadQuantities(); // load saved quantities after init
  }

  void _reloadQuantities() {
    // getCartData() returns: {'cartItems': List<PersistentShoppingCartItem>, 'totalPrice': double}
    final cartData = PersistentShoppingCart().getCartData();
    final items = cartData['cartItems'] as List<dynamic>? ?? <dynamic>[];
    _quantities.clear();
    for (final it in items) {
      if (it is PersistentShoppingCartItem) {
        _quantities[it.productId] = it.quantity;
      }
    }
    setState(() {}); // refresh UI
  }

  int _qtyFor(String sku) => _quantities[sku] ?? 0;

  Future<void> _increment(Product p) async {
    final cur = _qtyFor(p.sku);
    if (cur == 0) {
      // add product with quantity 1
      await PersistentShoppingCart().addToCart(
        PersistentShoppingCartItem(
          productId: p.sku,
          productName: p.title,
          productThumbnail: p.imageUrl,
          unitPrice: p.price,
          quantity: 1,
        ),
      );
    } else {
      // increment existing product's quantity by 1
      await PersistentShoppingCart().incrementCartItemQuantity(p.sku);
    }
    _reloadQuantities();
  }

  Future<void> _decrement(Product p) async {
    final cur = _qtyFor(p.sku);
    if (cur <= 1) {
      // remove completely
      await PersistentShoppingCart().removeFromCart(p.sku);
    } else {
      // reduce quantity by 1
      await PersistentShoppingCart().decrementCartItemQuantity(p.sku);
    }
    _reloadQuantities();
  }

  void _openCartScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CartScreen(onChange: _reloadQuantities),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      final isDark = context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
      //  backgroundColor: Colors.white,
        title:           Padding(
          padding: const EdgeInsets.only(top:4.0),
          child: ShaderMaskText(
                text: 'Punch Order',
                textxfontsize: 19),
        ),
        actions: [
          // Cart button (navigates to cart)
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: _openCartScreen,
          ),

          // Live item count widget from the package (updates automatically)
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: PersistentShoppingCart().showCartItemCountWidget(
              cartItemCountWidgetBuilder: (count) {
                if (count <= 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                  child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                );
              },
            ),
          ),
        ],
      ),
     // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
         //   const Center(child: Text("Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400))),
           GridView.builder(
  physics: const BouncingScrollPhysics(),
  shrinkWrap: true,
  padding: const EdgeInsets.all(12),
  itemCount: _products.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1, // still 1 card per row
    childAspectRatio: 1.8, // wider & smaller height
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  ),
  itemBuilder: (_, index) {
    final product = _products[index];
    final qty = _qtyFor(product.sku);
    return ProductCard(
      product: product,
      quantity: qty,
      onIncrement: () => _increment(product),
      onDecrement: () => _decrement(product),
    );
  },
)

          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
     final isDark = context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;
    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
               // color: Colors.transparent,
                product.imageUrl,
                width: 80,  // reduced image size
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
              children: [
                    Text(product.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                           SizedBox(width: 12),
                InkWell(
                  onTap: onDecrement,
                  child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.remove, color: Colors.white, size: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(quantity.toString(),
                      style: const TextStyle(fontSize: 14)),
                ),
                InkWell(
                  onTap: onIncrement,
                  child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.add, color: Colors.white, size: 16)),
                ),
                
              ],
            ),
                  // Text(product.title,
                  //     style: const TextStyle(
                  //         fontWeight: FontWeight.w600, fontSize: 14)),
                  Text("SKU: ${product.sku}",
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  Text("\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text("Mezan Group is one of Pakistan's leading FMCG companies, offering a range of products including edible oil, beverages, and tea. Over the last few years, Mezan has proven to be admired across Pakistan due to its wide variety of products",

                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
           /* Row(
              children: [
                InkWell(
                  onTap: onDecrement,
                  child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.remove, color: Colors.white, size: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(quantity.toString(),
                      style: const TextStyle(fontSize: 14)),
                ),
                InkWell(
                  onTap: onIncrement,
                  child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.add, color: Colors.white, size: 16)),
                ),
              ],
            )*/
          ],
        ),
      ),
    );
  }
}

