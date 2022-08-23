import 'package:flutter/cupertino.dart';

navigateTo({required BuildContext ctx, required String routeName}) {
  Navigator.pushNamed(ctx, routeName);
}

Future<void> showWarningDialog({
  required String title,
  required String subtitle,
  required Function fct,
  required BuildContext context,
}) async {
  showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Column(children: [
              const Icon(
                CupertinoIcons.wand_rays_inverse,
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(title),
            ]),
            content: Text(subtitle),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                isDefaultAction: true,
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                isDestructiveAction: true,
                child: const Text('OK'),
              ),
            ],
          ));
}

Future<void> showErrorDialog({
  required String subtitle,
  required BuildContext context,
}) async {
  showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Column(children: const [
              Icon(
                CupertinoIcons.eyedropper,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text('An Error occured'),
            ]),
            content: Text(subtitle),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                isDefaultAction: true,
                child: const Text('Ok'),
              ),
            ],
          ));
}

Future<void> addToCart(
    {required String productId,
    required int quantity,
    required BuildContext context}) async {
  // final User? user = authInstance.currentUser;
  // final _uid = user!.uid;
  // final cartId = const UUID().v4();
  // final cartId = 'cl:${context.owner.hashCode.toString()}';
  try {
    // FirebaseFirestore.instance.collection('users').doc(_uid).update({
    //   'userCart': FieldValue.arrayUnion([
    //     {
    //       'cartId': cartId,
    //       'productId': productId,
    //       'quantity': quantity,
    //     }
    //   ])
    // });
    showCupertinoSnackBar(
      context: context,
      message: "Item has been added to your cart",
    );
  } catch (error) {
    showErrorDialog(subtitle: error.toString(), context: context);
  }
}

Future<void> addToWishlist(
    {required String productId, required BuildContext context}) async {
  // final User? user = authInstance.currentUser;
  // final _uid = user!.uid;
  // final wishlistId = const Uuid().v4();
  // final wishlistId = 'ws:${context.owner.hashCode.toString()}';
  try {
    // FirebaseFirestore.instance.collection('users').doc(_uid).update({
    //   'userWish': FieldValue.arrayUnion([
    //     {
    //       'wishlistId': wishlistId,
    //       'productId': productId,
    //     }
    //   ])
    // });
    showCupertinoSnackBar(
      context: context,
      message: "Item has been added to your wishlist",
    );
  } catch (error) {
    showErrorDialog(subtitle: error.toString(), context: context);
  }
}

Future<void> showCupertinoSnackBar({
  required BuildContext context,
  required String message,
  int durationMillis = 2400,
}) async {
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 8.0,
      left: 8.0,
      right: 8.0,
      child: CupertinoPopupSurface(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Text(message,
              style: CupertinoTheme.of(context).textTheme.actionTextStyle),
        ),
      ),
    ),
  );
  Future.delayed(
    Duration(milliseconds: durationMillis),
    overlayEntry.remove,
  );
  Overlay.of(Navigator.of(context).context)?.insert(overlayEntry);
}
