import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/models/cart.dart';
import 'package:grossmx/providers/cartprovider.dart';
import 'package:grossmx/providers/orderprovider.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/providers/wishlistprovider.dart';
import 'package:grossmx/services/globalmethods.dart';
import 'package:grossmx/views/emptyview.dart';
import 'package:grossmx/views/productdetail.dart';
import 'package:grossmx/views/widgets.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyView(
            title: 'Your cart is empty',
            subtitle: 'Add something and be happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              automaticallyImplyLeading: false,
              // elevation: 0,
              backgroundColor:
                  CupertinoTheme.of(context).scaffoldBackgroundColor,
              middle: Text(
                'Cart (${cartItemsList.length})',
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              trailing: CupertinoButton(
                onPressed: () {
                  showWarningDialog(
                      title: 'Empty your cart?',
                      subtitle: 'Are you sure?',
                      fct: () async {
                        await cartProvider.clearOnlineCart();
                        cartProvider.clearLocalCart();
                      },
                      context: context);
                },
                child: Icon(
                  CupertinoIcons.rectangle_badge_checkmark,
                  color: color,
                ),
              ),
            ),
            child: Column(
              children: [
                _checkout(context: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItemsList[index],
                          child: CartWidget(
                            q: cartItemsList[index].quantity,
                          ));
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext context}) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final ordersProvider = Provider.of<OrderProvider>(context);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CupertinoColors.activeGreen,
            ),
            child: CupertinoButton(
              borderRadius: BorderRadius.circular(10),
              onPressed: () async {
                // User? user = authInstance.currentUser;
                // final orderId = const Uuid().v4();
                final orderId = 'or:${context.owner.hashCode.toString()}';
                final productProvider =
                    Provider.of<ProductProvider>(context, listen: false);

                cartProvider.getCartItems.forEach((key, value) async {
                  final getCurrProduct = productProvider.findProdById(
                    value.productId,
                  );
                  try {
                    // await FirebaseFirestore.instance
                    //     .collection('orders')
                    //     .doc(orderId)
                    //     .set({
                    //   'orderId': orderId,
                    //   'userId': user!.uid,
                    //   'productId': value.productId,
                    //   'price': (getCurrProduct.isOnSale
                    //           ? getCurrProduct.salePrice
                    //           : getCurrProduct.price) *
                    //       value.quantity,
                    //   'totalPrice': total,
                    //   'quantity': value.quantity,
                    //   'imageUrl': getCurrProduct.imageUrl,
                    //   'userName': user.displayName,
                    //   'orderDate': Timestamp.now(),
                    // });
                    await cartProvider.clearOnlineCart();
                    cartProvider.clearLocalCart();
                    ordersProvider.fetchOrders();
                    showCupertinoSnackBar(
                      context: context,
                      message: "Your order has been placed",
                    );
                  } catch (error) {
                    showErrorDialog(
                        subtitle: error.toString(), context: context);
                  } finally {}
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Order Now',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .pickerTextStyle
                      .copyWith(
                        color: CupertinoColors.white,
                      ),
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: CupertinoTheme.of(context).textTheme.navActionTextStyle,
            ),
          ),
        ]),
      ),
    );
  }
}

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q}) : super(key: key);
  final int q;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartModel = Provider.of<Cart>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetail.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoTheme.of(context)
                      .primaryContrastingColor
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Image.network(
                        getCurrProduct.imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getCurrProduct.title,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .tabLabelTextStyle
                              .copyWith(color: color, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: Row(
                            children: [
                              _quantityController(
                                fct: () {
                                  if (_quantityTextController.text == '1') {
                                    return;
                                  } else {
                                    cartProvider.reduceQuantityByOne(
                                        cartModel.productId);
                                    setState(() {
                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) -
                                              1)
                                          .toString();
                                    });
                                  }
                                },
                                color: CupertinoColors.destructiveRed,
                                icon: CupertinoIcons.minus,
                              ),
                              Flexible(
                                flex: 1,
                                child: CupertinoTextField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  // decoration:
                                  //  const InputDecoration(
                                  // focusedBorder: UnderlineInputBorder(
                                  //   borderSide: BorderSide(),
                                  // ),
                                  // ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      if (v.isEmpty) {
                                        _quantityTextController.text = '1';
                                      } else {
                                        return;
                                      }
                                    });
                                  },
                                ),
                              ),
                              _quantityController(
                                fct: () {
                                  cartProvider.increaseQuantityByOne(
                                      cartModel.productId);
                                  setState(() {
                                    _quantityTextController.text = (int.parse(
                                                _quantityTextController.text) +
                                            1)
                                        .toString();
                                  });
                                },
                                color: CupertinoColors.activeGreen,
                                icon: CupertinoIcons.plus,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          CupertinoButton(
                            onPressed: () async {
                              await cartProvider.removeOneItem(
                                cartId: cartModel.id,
                                productId: cartModel.productId,
                                quantity: cartModel.quantity,
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: CupertinoColors.destructiveRed,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FavBtn(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                          Text(
                            '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .pickerTextStyle
                                .copyWith(color: color, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CupertinoButton(
            borderRadius: BorderRadius.circular(12),
            onPressed: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
