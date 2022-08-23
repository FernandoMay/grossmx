import 'package:flutter/cupertino.dart';

class Cart with ChangeNotifier {
  final String id, productId;
  final int quantity;

  Cart({
    required this.id,
    required this.productId,
    required this.quantity,
  });
}
