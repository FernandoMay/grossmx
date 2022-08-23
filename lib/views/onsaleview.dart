import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/models/product.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/views/widgets.dart';
import 'package:provider/provider.dart';

class OnSaleView extends StatelessWidget {
  static const routeName = "/OnSale";
  const OnSaleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductProvider>(context);
    List<Product> productsOnSale = productProviders.getOnSaleProducts;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(),
        // elevation: 0,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        middle: Text(
          'Products on sale',
          style: CupertinoTheme.of(context)
              .textTheme
              .navTitleTextStyle
              .copyWith(color: color),
        ),
      ),
      child: productsOnSale.isEmpty
          ? const EmptyWidget(
              text: 'No products on sale yet!,\nStay tuned',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(productsOnSale.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productsOnSale[index],
                  child: const OnSaleWidget(),
                );
              }),
            ),
    );
  }
}
