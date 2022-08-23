import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/models/product.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/views/widgets.dart';
import 'package:provider/provider.dart';

class FeedView extends StatefulWidget {
  static const routeName = "/Feed";
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productsProvider.fetchProducts();
    super.initState();
  }

  List<Product> listProdcutSearch = [];
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductProvider>(context);
    List<Product> allProducts = productsProvider.getProducts;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(),
        // elevation: 0,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        // centerTitle: true,
        middle: Text(
          'All Products',
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: CupertinoSearchTextField(
                focusNode: _searchTextFocusNode,
                controller: _searchTextController,
                // placeholder: ,
                onChanged: (valuee) {
                  setState(() {
                    listProdcutSearch = productsProvider.searchQuery(valuee);
                  });
                },
              ),
              //  CupertinoTextField(
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide:
              //           const BorderSide(color: Colors.greenAccent, width: 1),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide:
              //           const BorderSide(color: Colors.greenAccent, width: 1),
              //     ),
              //     hintText: "What's in your mind",
              //     prefix: const Icon(Icons.search),
              //     suffix: CupertinoButton(
              //       onPressed: () {
              //         _searchTextController!.clear();
              //         _searchTextFocusNode.unfocus();
              //       },
              //       child: Icon(
              //         CupertinoIcons.clear,
              //         color: _searchTextFocusNode.hasFocus ? Colors.red : color,
              //       ),
              //     ),

              // ),
            ),
          ),
          _searchTextController!.text.isNotEmpty && listProdcutSearch.isEmpty
              ? const EmptyWidget(
                  text: 'No products found, please try another keyword')
              : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: EdgeInsets.zero,
                  // crossAxisSpacing: 10,
                  childAspectRatio: size.width / (size.height * 0.61),
                  children: List.generate(
                      _searchTextController!.text.isNotEmpty
                          ? listProdcutSearch.length
                          : allProducts.length, (index) {
                    return ChangeNotifierProvider.value(
                      value: _searchTextController!.text.isNotEmpty
                          ? listProdcutSearch[index]
                          : allProducts[index],
                      child: const FeedWidget(),
                    );
                  }),
                ),
        ]),
      ),
    );
  }
}
