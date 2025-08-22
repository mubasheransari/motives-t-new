import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:motives_tneww/Features/punch_order/punch_order.dart';
import 'package:motives_tneww/widget/toast_widget.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart'
    show PersistentShoppingCart;
import '../../Models/product_model.dart';
import '../../screens/dashboard.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

bool isPasswordVisible = false;
TextEditingController shopReview = TextEditingController();



class CartScreen extends StatefulWidget {
  final VoidCallback? onChange;
  const CartScreen({super.key, this.onChange});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

     final _recorder = AudioRecorder(); // ✅ new in record 6.x
  final _player = AudioPlayer();

  String? _filePath;
  bool _isRecording = false;

  Future<void> _startRecording() async {
    // Check permission
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc), // ✅ new config
        path: path,
      );

      setState(() {
        _filePath = path;
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();

    setState(() {
      _isRecording = false;
      _filePath = path;
    });
  }

  Future<void> _playRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await _player.play(DeviceFileSource(_filePath!));
    }
  }

  Future<void> _deleteRecording() async {
    if (_filePath != null) {
      final file = File(_filePath!);
      if (await file.exists()) {
        await file.delete();
      }
      setState(() {
        _filePath = null;
      });
    }
  }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: ShaderMaskText(text: 'Cart', textxfontsize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () {
              PersistentShoppingCart().clearCart();
              widget.onChange?.call();
              setState(() {});
              toastWidget("Deleted All Cart Items", Colors.red);
            },
            child: Icon(
              Icons.delete,
              size: 25,
              color: Colors.red,
            ), //const Text('Clear', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: PersistentShoppingCart().showCartItems(
        cartItemsBuilder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = cartItems[index];

              final product = Product(
                title: item.productName,
                sku: item.productId,
                imageUrl: item.productThumbnail ?? "assets/placeholder.png",
                price: item.unitPrice,
              );

              return Stack(
                children: [
                  ProductCard(
                    product: product,
                    quantity: item.quantity,
                    onIncrement: () async {
                      await PersistentShoppingCart().incrementCartItemQuantity(
                        item.productId,
                      );
                      widget.onChange?.call();
                      setState(() {});
                    },
                    onDecrement: () async {
                      if (item.quantity <= 1) {
                        await PersistentShoppingCart().removeFromCart(
                          item.productId,
                        );
                      } else {
                        await PersistentShoppingCart()
                            .decrementCartItemQuantity(item.productId);
                      }
                      widget.onChange?.call();
                      setState(() {});
                    },
                  ),
                  Positioned(
                    top: 0,
                    right: 2,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await PersistentShoppingCart().removeFromCart(
                          item.productId,
                        );
                        widget.onChange?.call();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: PersistentShoppingCart().showTotalAmountWidget(
          cartTotalAmountWidgetBuilder: (total) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total: ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${PersistentShoppingCart().getCartItemCount()} item(s)',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                  width: 130,
                  child: InkWell(
                    onTap: PersistentShoppingCart().getCartItemCount() == 0
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          "Are you sure, you want to confirm the order?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.black
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          "Shop Owner Review About Mezan Tea",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            // color: Colors.black
                                          ),
                                        ),
                                        Divider(),
                                        _customTextField(
                                          controller: shopReview,
                                          hint: "Shop Owner Review",
                                          icon: Icons.reviews,
                                          isDark: isDark,
                                        ),
                                        Text(
                                          "OR",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          "Record a Voice Message",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            // color: Colors.black
                                          ),
                                        ),

                                        Divider(),
                                          ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playRecording,
              child: const Text("Play Recording"),
            ),
            //                           ElevatedButton(
            //   onPressed: _isRecording ? _stopRecording : _startRecording,
            //   child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            // ),
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _playRecording,
            //   child: const Text("Play Recording"),
            // ),
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _deleteRecording,
            //   child: const Text("Delete Recording"),
            // ),
                                        SizedBox(height: 25),
                                        InkWell(
                                          onTap: () {
                                            // Navigator.of(context).pop();
                                            PersistentShoppingCart()
                                                .clearCart();
                                            widget.onChange?.call();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            toastWidget(
                                              "Order Confirmed",
                                              Colors.green,
                                            );
                                          },
                                          child: Ink(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Colors.cyan,
                                                  Colors.purpleAccent,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Confirm Order',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            /* showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Checkout'),
                                content:
                                    Text('Total: ${total.toStringAsFixed(2)}'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      PersistentShoppingCart().clearCart();
                                      widget.onChange?.call();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Order placed (demo)')));
                                    },
                                    child: const Text('Place Order'),
                                  ),
                                ],
                              ),
                            );*/
                          },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.cyan, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Place Order',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        prefixIcon: Icon(icon, color: Colors.cyan),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
