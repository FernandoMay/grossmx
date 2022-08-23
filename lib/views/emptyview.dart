import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/services/globalmethods.dart';
import 'package:grossmx/views/feedview.dart';

class EmptyView extends StatelessWidget {
  const EmptyView(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText})
      : super(key: key);
  final String imagePath, title, subtitle, buttonText;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final themeState = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        //leading: CupertinoNavigationBarBackButton(),
        // elevation: 0,
        // centerTitle: false,
        middle: Text(
          'xc',
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        backgroundColor:
            CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      ),
      child: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  imagePath,
                  width: double.infinity,
                  height: size.height * 0.4,
                ),
                Text(
                  'Vaya vaya!',
                  style: CupertinoTheme.of(context).textTheme.actionTextStyle,
                ),
                Text(
                  title,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .copyWith(color: CupertinoColors.systemIndigo),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .copyWith(
                        color: CupertinoColors.systemIndigo.withOpacity(0.8),
                      ),
                ),
                CupertinoButton.filled(
                  // style: ElevatedButton.styleFrom(
                  // elevation: 0,
                  // shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  // side: BorderSide(
                  //   color: color,
                  // ),
                  // ),
                  disabledColor:
                      CupertinoTheme.of(context).primaryContrastingColor,
                  // onPrimary: color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
                  // ),
                  onPressed: () {
                    navigateTo(ctx: context, routeName: FeedView.routeName);
                  },
                  child: Text(
                    buttonText,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle
                        .copyWith(
                            // fontSize: 20,
                            color: themeState
                                ? CupertinoColors.systemGrey3
                                : CupertinoColors.systemGrey6),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
