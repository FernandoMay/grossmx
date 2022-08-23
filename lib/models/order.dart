import 'package:flutter/cupertino.dart';

class Order with ChangeNotifier {
  final String orderId, userId, productId, userName, price, imageUrl, quantity;
  final DateTime orderDate;

  Order(
      {required this.orderId,
      required this.userId,
      required this.productId,
      required this.userName,
      required this.price,
      required this.imageUrl,
      required this.quantity,
      required this.orderDate});
}
