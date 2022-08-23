import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/providers/wishlistprovider.dart';
import 'package:grossmx/services/globalmethods.dart';
import 'package:grossmx/views/emptyview.dart';
import 'package:grossmx/views/productdetail.dart';
import 'package:grossmx/views/widgets.dart';
import 'package:provider/provider.dart';

class WishlistView extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemsList.isEmpty
        ? const EmptyView(
            title: 'Your Wishlist Is Empty',
            subtitle: 'Explore more and shortlist some items',
            imagePath: 'assets/images/wishlist.png',
            buttonText: 'Add a wish',
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              // centerTitle: true,
              leading: CupertinoNavigationBarBackButton(),
              automaticallyImplyLeading: false,
              // elevation: 0,
              backgroundColor:
                  CupertinoTheme.of(context).scaffoldBackgroundColor,
              middle: Text(
                'Wishlist (${wishlistItemsList.length})',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .navTitleTextStyle
                    .copyWith(
                      color: color,
                    ),
              ),
              trailing: CupertinoButton(
                onPressed: () {
                  showWarningDialog(
                      title: 'Empty your wishlist?',
                      subtitle: 'Are you sure?',
                      fct: () async {
                        await wishlistProvider.clearOnlineWishlist();
                        wishlistProvider.clearLocalWishlist();
                      },
                      context: context);
                },
                child: Icon(
                  CupertinoIcons.delete,
                  color: color,
                ),
              ),
            ),
            child: GridView.builder(
              itemCount: wishlistItemsList.length,
              // crossAxisCount: 2,
              // mainAxisSpacing: 16,
              // crossAxisSpacing: 20,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishlistItemsList[index],
                    child: const WishlistWidget());
              },
            ));
  }
}

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistModel = Provider.of<Wishlist>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getCurrProduct =
        productProvider.findProdById(wishlistModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetail.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).primaryContrastingColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: Image.network(
                    getCurrProduct.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          CupertinoButton(
                            onPressed: () {},
                            child: Icon(
                              CupertinoIcons.bag_fill,
                              color: color,
                            ),
                          ),
                          FavBtn(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishlist,
                          )
                        ],
                      ),
                    ),
                    Text(
                      getCurrProduct.title,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .tabLabelTextStyle
                          .copyWith(color: color, fontSize: 20.0),
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$${usedPrice.toStringAsFixed(2)}',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .pickerTextStyle
                          .copyWith(color: color, fontSize: 18.0),
                      maxLines: 1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
