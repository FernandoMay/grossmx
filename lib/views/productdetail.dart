import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/providers/cartprovider.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/providers/wishlistprovider.dart';
import 'package:grossmx/services/globalmethods.dart';
import 'package:grossmx/views/widgets.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  static const routeName = '/ProductDetail';

  const ProductDetail({Key? key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;

    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(productId);

    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);

    // final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        // viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: const CupertinoNavigationBarBackButton(),
            // elevation: 0,
            backgroundColor:
                CupertinoTheme.of(context).scaffoldBackgroundColor),
        child: Column(children: [
          Flexible(
            flex: 2,
            child: Image.network(
              getCurrProduct.imageUrl,
              fit: BoxFit.scaleDown,
              width: size.width,
              // height: screenHeight * .4,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).primaryContrastingColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            getCurrProduct.title,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navTitleTextStyle
                                .copyWith(
                                  color: color,
                                  fontSize: 25,
                                ),
                          ),
                        ),
                        FavBtn(
                          productId: getCurrProduct.id,
                          isInWishlist: _isInWishlist,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${usedPrice.toStringAsFixed(2)}',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .pickerTextStyle
                              .copyWith(
                                color: CupertinoColors.activeGreen,
                                fontSize: 22,
                              ),
                        ),
                        Text(
                          getCurrProduct.isPiece ? '/Piece' : '/Kg',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .dateTimePickerTextStyle
                              .copyWith(
                                color: color,
                                fontSize: 12,
                              ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: getCurrProduct.isOnSale ? true : false,
                          child: Text(
                            '\$${getCurrProduct.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 15,
                                color: color,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(63, 200, 101, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            'Free delivery?',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .dateTimePickerTextStyle
                                .copyWith(
                                  color: CupertinoColors.white,
                                  fontSize: 20,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      quantityControl(
                        fct: () {
                          if (_quantityTextController.text == '1') {
                            return;
                          } else {
                            setState(() {
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text) - 1)
                                      .toString();
                            });
                          }
                        },
                        icon: CupertinoIcons.minus,
                        color: CupertinoColors.systemRed,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: CupertinoTextField(
                          controller: _quantityTextController,
                          key: const ValueKey('quantity'),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          cursorColor: CupertinoColors.activeGreen,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                _quantityTextController.text = '1';
                              } else {}
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      quantityControl(
                        fct: () {
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) + 1)
                                    .toString();
                          });
                        },
                        icon: CupertinoIcons.plus,
                        color: CupertinoColors.activeGreen,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: CupertinoTheme.of(context).primaryContrastingColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .tabLabelTextStyle
                                    .copyWith(
                                      color: CupertinoColors.placeholderText,
                                      fontSize: 20,
                                    ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      '\$${totalPrice.toStringAsFixed(2)}/',
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .navTitleTextStyle
                                          .copyWith(
                                            color: color,
                                            fontSize: 20,
                                          ),
                                    ),
                                    Text(
                                      '${_quantityTextController.text}Kg',
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .dateTimePickerTextStyle
                                          .copyWith(
                                            color: color,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Container(
                            color: CupertinoColors.systemGreen,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CupertinoButton(
                              onPressed: _isInCart
                                  ? null
                                  : () async {
                                      // if (_isInCart) {
                                      //   return;
                                      // }
                                      // final User? user =
                                      //     authInstance.currentUser;

                                      // if (user == null) {
                                      //   showErrorDialog(
                                      //       subtitle:
                                      //           'No user found, Please login first',
                                      //       context: context);
                                      //   return;
                                      // }
                                      await addToCart(
                                          productId: getCurrProduct.id,
                                          quantity: int.parse(
                                              _quantityTextController.text),
                                          context: context);
                                      await cartProvider.fetchCart();
                                      // cartProvider.addProductsToCart(
                                      //     productId: getCurrProduct.id,
                                      //     quantity: int.parse(
                                      //         _quantityTextController.text));
                                    },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  _isInCart ? 'In cart' : 'Add to cart',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .pickerTextStyle
                                      .copyWith(
                                          color: CupertinoColors.white,
                                          fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        color: color,
        child: CupertinoButton(
            borderRadius: BorderRadius.circular(12),
            onPressed: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: CupertinoColors.white,
                size: 25,
              ),
            )),
      ),
    );
  }
}
