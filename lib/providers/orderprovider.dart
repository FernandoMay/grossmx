import 'package:flutter/cupertino.dart';
import 'package:grossmx/models/order.dart';

class OrderProvider with ChangeNotifier {
  static List<Order> _orders = [];
  List<Order> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    // await FirebaseFirestore.instance
    //     .collection('orders')
    //     .get()
    //     .then((QuerySnapshot ordersSnapshot) {
    //   _orders = [];
    //   // _orders.clear();
    //   ordersSnapshot.docs.forEach((element) {
    //     _orders.insert(
    //       0,
    //       Order(
    //         orderId: element.get('orderId'),
    //         userId: element.get('userId'),
    //         productId: element.get('productId'),
    //         userName: element.get('userName'),
    //         price: element.get('price').toString(),
    //         imageUrl: element.get('imageUrl'),
    //         quantity: element.get('quantity').toString(),
    //         orderDate: element.get('orderDate'),
    //       ),
    //     );
    //   });
    // });
    notifyListeners();
  }
}
