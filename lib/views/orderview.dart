import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/models/order.dart';
import 'package:grossmx/providers/orderprovider.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/services/globalmethods.dart';
import 'package:grossmx/views/emptyview.dart';
import 'package:grossmx/views/productdetail.dart';
import 'package:provider/provider.dart';

class OrderView extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrderProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const EmptyView(
                  title: 'You didnt place any order yet',
                  subtitle: 'order something and be happy :)',
                  buttonText: 'Shop now',
                  imagePath: 'assets/images/cart.png',
                )
              : CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    leading: const CupertinoNavigationBarBackButton(),
                    // elevation: 0,
                    // centerTitle: false,
                    middle: Text(
                      'Your orders (${ordersList.length})',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle,
                    ),
                    backgroundColor: CupertinoTheme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  child: ListView.separated(
                    itemCount: ordersList.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                          value: ordersList[index],
                          child: const OrderWidget(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        color: color,
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        // thickness: 1,
                      );
                    },
                  ));
        });
  }
}

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<Order>(context);
    var orderDate = ordersModel.orderDate.toUtc();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<Order>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    return CupertinoButton(
      onPressed: () {
        navigateTo(ctx: context, routeName: ProductDetail.routeName);
      },
      child: Row(
        children: [
          Image.network(
            getCurrProduct.imageUrl,
            width: size.width * 0.2,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              Text(
                '${getCurrProduct.title}  x${ordersModel.quantity}',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .navTitleTextStyle
                    .copyWith(color: color, fontSize: 18),
              ),
              Text(
                'Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .dateTimePickerTextStyle,
              ),
            ],
          ),
          Text(
            orderDateToShow,
            style: CupertinoTheme.of(context)
                .textTheme
                .navTitleTextStyle
                .copyWith(color: color, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
