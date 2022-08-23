import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/models/product.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/services/globalmethods.dart';
import 'package:grossmx/views/feedview.dart';
import 'package:grossmx/views/onsaleview.dart';
import 'package:grossmx/views/widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductProvider>(context);
    List<Product> allProducts = productProviders.getProducts;
    List<Product> productsOnSale = productProviders.getOnSaleProducts;
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.33,
              //child:
              //Swiper(
              //   itemBuilder: (BuildContext context, int index) {
              //     return Image.asset(
              //       Constss.offerImages[index],
              //       fit: BoxFit.fill,
              //     );
              //   },
              //   autoplay: true,
              //   itemCount: Constss.offerImages.length,
              //   pagination: const SwiperPagination(
              //       alignment: Alignment.bottomCenter,
              //       builder: DotSwiperPaginationBuilder(
              //           color: Colors.white, activeColor: Colors.red)),
              //   // control: const SwiperControl(color: Colors.black),
              // ),
            ),
            const SizedBox(
              height: 6,
            ),
            CupertinoButton(
              onPressed: () {
                navigateTo(ctx: context, routeName: OnSaleView.routeName);
              },
              child: Text('View all',
                  maxLines: 1,
                  style:
                      CupertinoTheme.of(context).textTheme.tabLabelTextStyle),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                const SizedBox(width: 8),
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      Text(
                        'On sale'.toUpperCase(),
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle,
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        CupertinoIcons.percent,
                        color: CupertinoColors.systemRed,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.33,
                    child: ListView.builder(
                      itemCount: productsOnSale.length < 10
                          ? productsOnSale.length
                          : 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: productsOnSale[index],
                            child: const OnSaleWidget());
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Our products',
                    style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
                  ),
                  // const Spacer(),
                  CupertinoButton(
                    onPressed: () {
                      navigateTo(ctx: context, routeName: FeedView.routeName);
                    },
                    child: Text(
                      'Browse all',
                      maxLines: 1,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .tabLabelTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.all(2.0),
              // crossAxisSpacing: 10,
              // childAspectRatio: 2 / 3,
              children: List.generate(
                  allProducts.length < 4
                      ? allProducts.length // length 3
                      : 4, (index) {
                return ChangeNotifierProvider.value(
                  value: allProducts[index],
                  child: const FeedWidget(),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
