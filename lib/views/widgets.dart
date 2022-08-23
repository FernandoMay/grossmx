import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/models/product.dart';
import 'package:grossmx/providers/cartprovider.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/providers/wishlistprovider.dart';
import 'package:grossmx/services/globalmethods.dart';
import 'package:grossmx/views/productdetail.dart';
import 'package:provider/provider.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    double userPrice = isOnSale ? salePrice : price;
    return FittedBox(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: isOnSale ? true : false,
          child: Text(
            '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              color: color,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
          style: CupertinoTheme.of(context)
              .textTheme
              .actionTextStyle
              .copyWith(color: CupertinoColors.systemGreen, fontSize: 22),
        ),
      ],
    ));
  }
}

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<Product>(context);
    // final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return CupertinoButton(
      // borderRadius: BorderRadius.circular(10),
      onPressed: () {
        // Navigator.pushNamed(context, ProductDetail.routeName,
        //     arguments: productModel.id);
        // GlobalMethods.navigateTo(
        //     ctx: context, routeName: ProductDetails.routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        // height: size.height * 0.33,
        // width: size.width * 0.33,
        decoration: BoxDecoration(
          color: CupertinoColors.lightBackgroundGray.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(
                      productModel.imageUrl,
                      height: size.width * 0.31,
                      width: size.width * 0.31,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          onPressed: _isInCart
                              ? null
                              : () async {
                                  // final User? user =
                                  //     authInstance.currentUser;

                                  // if (user == null) {
                                  //   GlobalMethods.errorDialog(
                                  //       subtitle:
                                  //           'No user found, Please login first',
                                  //       context: context);
                                  //   return;
                                  // }
                                  await addToCart(
                                      productId: productModel.id,
                                      quantity: 1,
                                      context: context);
                                  await cartProvider.fetchCart();
                                  cartProvider.addProductsToCart(
                                      productId: productModel.id, quantity: 1);
                                },
                          child: Icon(
                            _isInCart
                                ? CupertinoIcons.bag_fill
                                : CupertinoIcons.bag_badge_plus,
                            size: 22,
                            color: _isInCart
                                ? CupertinoColors.systemGreen
                                : CupertinoColors.activeOrange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FavBtn(
                          productId: productModel.id,
                          isInWishlist: _isInWishlist,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: '1',
                  isOnSale: true,
                ),
                const SizedBox(height: 5),
                Text(
                  productModel.isPiece ? '1 Piece' : '1 Kg',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .tabLabelTextStyle
                      .copyWith(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  productModel.title,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .copyWith(
                        color: color,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 3),
              ]),
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(
                'assets/images/box.png',
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
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
    final productModel = Provider.of<Product>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return CupertinoButton(
      onPressed: () {
        Navigator.pushNamed(context, ProductDetail.routeName,
            arguments: productModel.id);
        // GlobalMethods.navigateTo(
        //     ctx: context, routeName: ProductDetails.routeName);
      },
      // borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CupertinoTheme.of(context).primaryContrastingColor,
        ),
        child: Column(children: [
          Image.network(
            productModel.imageUrl,
            height: size.width * 0.2,
            width: size.width * 0.2,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    productModel.title,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle
                        .copyWith(
                          color: color,
                          fontSize: 18,
                        ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: FavBtn(
                      productId: productModel.id,
                      isInWishlist: _isInWishlist,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: PriceWidget(
                    salePrice: productModel.salePrice,
                    price: productModel.price,
                    textPrice: _quantityTextController.text,
                    isOnSale: productModel.isOnSale,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 6,
                        child: FittedBox(
                          child: Text(
                            productModel.isPiece ? 'Piece' : 'kg',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .dateTimePickerTextStyle
                                .copyWith(
                                  color: color,
                                  fontSize: 20,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
                onPressed: _isInCart
                    ? null
                    : () async {
                        // if (_isInCart) {
                        //   return;
                        // }
                        // final User? user = authInstance.currentUser;

                        // if (user == null) {
                        //   GlobalMethods.errorDialog(
                        //       subtitle: 'No user found, Please login first',
                        //       context: context);
                        //   return;
                        // }
                        await addToCart(
                            productId: productModel.id,
                            quantity: int.parse(_quantityTextController.text),
                            context: context);
                        await cartProvider.fetchCart();
                        // cartProvider.addProductsToCart(
                        //     productId: productModel.id,
                        //     quantity: int.parse(_quantityTextController.text));
                      },
                // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                disabledColor: CupertinoColors.destructiveRed,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
                child: Text(
                  _isInCart ? 'In cart' : 'Add to cart',
                  maxLines: 1,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navActionTextStyle
                      .copyWith(
                        color: CupertinoColors.systemGrey6,
                      ),
                )),
          ),
          // )
        ]),
      ),
    );
  }
}

class FavBtn extends StatefulWidget {
  const FavBtn({Key? key, required this.productId, this.isInWishlist = false})
      : super(key: key);
  final String productId;
  final bool? isInWishlist;

  @override
  State<FavBtn> createState() => _FavBtnState();
}

class _FavBtnState extends State<FavBtn> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return CupertinoButton(
      onPressed: () async {
        setState(() {
          loading = true;
        });
        try {
          // final User? user = authInstance.currentUser;

          // if (user == null) {
          //   showErrorDialog(
          //       subtitle: 'No user found, Please login first',
          //       context: context);
          //   return;
          // }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await addToWishlist(productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
                productId: widget.productId);
          }
          await wishlistProvider.fetchWishlist();
          setState(() {
            loading = false;
          });
        } catch (error) {
          showErrorDialog(subtitle: '$error', context: context);
        } finally {
          setState(() {
            loading = false;
          });
        }
        // print('user id is ${user.uid}');
        // wishlistProvider.addRemoveProductToWishlist(productId: productId);
      },
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 15, width: 15, child: CupertinoActivityIndicator()),
            )
          : Icon(
              widget.isInWishlist != null && widget.isInWishlist == true
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              size: 22,
              color: widget.isInWishlist != null && widget.isInWishlist == true
                  ? CupertinoColors.systemRed
                  : color,
            ),
    );
  }
}
