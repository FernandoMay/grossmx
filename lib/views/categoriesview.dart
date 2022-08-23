import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/models/product.dart';
import 'package:grossmx/providers/darkthemeprovider.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/views/emptyview.dart';
import 'package:grossmx/views/widgets.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatelessWidget {
  CategoriesView({Key? key}) : super(key: key);

  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/fruits.png',
      'catText': 'Fruits',
    },
    {
      'imgPath': 'assets/images/cat/veg.png',
      'catText': 'Vegetables',
    },
    {
      'imgPath': 'assets/images/cat/Spinach.png',
      'catText': 'Herbs',
    },
    {
      'imgPath': 'assets/images/cat/nuts.png',
      'catText': 'Nuts',
    },
    {
      'imgPath': 'assets/images/cat/spices.png',
      'catText': 'Spices',
    },
    {
      'imgPath': 'assets/images/cat/grains.png',
      'catText': 'Grains',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          // elevation: 0,
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,

          middle: Text(
            'Categories',
            style: CupertinoTheme.of(context)
                .textTheme
                .navTitleTextStyle
                .copyWith(color: color),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10, // Vertical spacing
            mainAxisSpacing: 10, // Horizontal spacing
            children: List.generate(6, (index) {
              return CategoryWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            }),
          ),
        ));
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {Key? key,
      required this.catText,
      required this.imgPath,
      required this.passedColor})
      : super(key: key);
  final String catText, imgPath;
  final Color passedColor;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    double _screenWidth = MediaQuery.of(context).size.width;
    final Color color =
        themeState.getDarkTheme ? CupertinoColors.white : CupertinoColors.black;
    return CupertinoButton(
      onPressed: () {
        Navigator.pushNamed(context, CategoryView.routeName,
            arguments: catText);
      },
      child: Container(
        // height: _screenWidth * 0.6,
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: passedColor.withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Column(children: [
          // Container for the image
          Container(
            height: _screenWidth * 0.3,
            width: _screenWidth * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    imgPath,
                  ),
                  fit: BoxFit.fill),
            ),
          ),
          // Category name
          Text(
            catText,
            style: CupertinoTheme.of(context)
                .textTheme
                .tabLabelTextStyle
                .copyWith(color: color, fontSize: 20),
          ),
        ]),
      ),
    );
  }
}

class CategoryView extends StatefulWidget {
  static const routeName = "/CategoryScreenState";
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<Product> listProdcutSearch = [];
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<Product> productByCat = productsProvider.findByCategory(catName);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(),
        // elevation: 0,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        // centerTitle: true,
        middle: Text(
          catName,
          style: CupertinoTheme.of(context)
              .textTheme
              .navTitleTextStyle
              .copyWith(color: color),
        ),
      ),
      child: productByCat.isEmpty
          ? const EmptyWidget(
              text: 'No products belong to this category',
            )
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: CupertinoSearchTextField(
                      focusNode: _searchTextFocusNode,
                      controller: _searchTextController,
                      onChanged: (value) {
                        setState(() {
                          listProdcutSearch =
                              productsProvider.searchQuery(value);
                        });
                      },
                      // decoration: InputDecoration(
                      //   focusedBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //     borderSide: const BorderSide(
                      //         color: Colors.greenAccent, width: 1),
                      //   ),
                      //   enabledBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //     borderSide: const BorderSide(
                      //         color: Colors.greenAccent, width: 1),
                      //   ),
                      //   hintText: "What's in your mind",
                      //   prefixIcon: const Icon(Icons.search),
                      //   suffix: IconButton(
                      //     onPressed: () {
                      //       _searchTextController!.clear();
                      //       _searchTextFocusNode.unfocus();
                      //     },
                      //     icon: Icon(
                      //       Icons.close,
                      //       color: _searchTextFocusNode.hasFocus
                      //           ? Colors.red
                      //           : color,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                ),
                _searchTextController!.text.isNotEmpty &&
                        listProdcutSearch.isEmpty
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
                                : productByCat.length, (index) {
                          return ChangeNotifierProvider.value(
                            value: _searchTextController!.text.isNotEmpty
                                ? listProdcutSearch[index]
                                : productByCat[index],
                            child: const FeedWidget(),
                          );
                        }),
                      ),
              ]),
            ),
    );
  }
}
