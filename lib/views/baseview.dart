import 'package:flutter/cupertino.dart';
import 'package:grossmx/providers/cartprovider.dart';
import 'package:grossmx/providers/darkthemeprovider.dart';
import 'package:grossmx/views/cartview.dart';
import 'package:grossmx/views/categoriesview.dart';
import 'package:grossmx/views/home.dart';
import 'package:grossmx/views/wishlistview.dart';
import 'package:provider/provider.dart';

class BaseView extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'page': const Home(),
      'title': 'Home',
    },
    {
      'page': CategoriesView(),
      'title': 'Categories',
    },
    {
      'page': const CartView(),
      'title': 'Cart',
    },
    {
      'page': const WishlistView(),
      'title': 'Wishlist',
    },
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    bool _isDark = themeState.getDarkTheme;
    return CupertinoTabScaffold(
      // appBar: AppBar(
      //   title: Text( _pages[_selectedIndex]['title']),
      // ),
      tabBar: CupertinoTabBar(
        backgroundColor: _isDark
            ? CupertinoTheme.of(context).primaryContrastingColor
            : CupertinoColors.white,
        // type: BottomNavigationBarType.fixed,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        // unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
        // selectedItemColor: _isDark ? Colors.lightBlue.shade200 : Colors.black87,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0
                ? CupertinoIcons.home
                : CupertinoIcons.hand_thumbsdown),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? CupertinoIcons.create
                : CupertinoIcons.create_solid),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
              return Badge(
                // toAnimate: true,
                // shape: BadgeShape.circle,
                // badgeColor: CupertinoColors.systemRed,
                // borderRadius: BorderRadius.circular(8),
                // position: BadgePosition.topEnd(top: -7, end: -7),
                right: -4,
                top: -4,
                value: myCart.getCartItems.length.toString(),
                child: Icon(_selectedIndex == 2
                    ? CupertinoIcons.battery_full
                    : CupertinoIcons.bubble_left),
              );
            }),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 3
                ? CupertinoIcons.person_2
                : CupertinoIcons.person_2_alt),
            label: "User",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (context) => _pages[_selectedIndex]['page'],
        );
      },
    );
  }
}

class Badge extends StatelessWidget {
  final double top;
  final double right;
  final Widget child; // our badge widget will wrap this child widget
  final String value; // what displays inside the badge
  final Color color; // the  background color of the badge - default is red

  const Badge(
      {Key? key,
      required this.child,
      required this.value,
      this.color = CupertinoColors.systemRed,
      required this.top,
      required this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: right,
          top: top,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: CupertinoColors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
