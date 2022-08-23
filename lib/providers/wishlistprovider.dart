import 'package:flutter/cupertino.dart';

class Wishlist with ChangeNotifier {
  final String id, productId;

  Wishlist({
    required this.id,
    required this.productId,
  });
}

class WishlistProvider with ChangeNotifier {
  Map<String, Wishlist> _wishlistItems = {};

  Map<String, Wishlist> get getWishlistItems {
    return _wishlistItems;
  }

  // void addRemoveProductToWishlist({required String productId}) {
  //   if (_wishlistItems.containsKey(productId)) {
  //     removeOneItem(productId);
  //   } else {
  //     _wishlistItems.putIfAbsent(
  //         productId,
  //         () => WishlistModel(
  //             id: DateTime.now().toString(), productId: productId));
  //   }
  //   notifyListeners();
  // }

  // final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> fetchWishlist() async {
    // final User? user = authInstance.currentUser;
    // final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    // if (userDoc == null) {
    //   return;
    // }
    // final leng = userDoc.get('userWish').length;
    // for (int i = 0; i < leng; i++) {
    //   _wishlistItems.putIfAbsent(
    //       userDoc.get('userWish')[i]['productId'],
    //       () => WishlistModel(
    //             id: userDoc.get('userWish')[i]['wishlistId'],
    //             productId: userDoc.get('userWish')[i]['productId'],
    //           ));
    // }
    notifyListeners();
  }

  Future<void> removeOneItem({
    required String wishlistId,
    required String productId,
  }) async {
    // final User? user = authInstance.currentUser;
    // await userCollection.doc(user!.uid).update({
    //   'userWish': FieldValue.arrayRemove([
    //     {
    //       'wishlistId': wishlistId,
    //       'productId': productId,
    //     }
    //   ])
    // });
    _wishlistItems.remove(productId);
    await fetchWishlist();
    notifyListeners();
  }

  Future<void> clearOnlineWishlist() async {
    // final User? user = authInstance.currentUser;
    // await userCollection.doc(user!.uid).update({
    //   'userWish': [],
    // });
    _wishlistItems.clear();
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
