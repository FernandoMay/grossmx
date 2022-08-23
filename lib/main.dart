import 'package:flutter/cupertino.dart';
import 'package:grossmx/constants.dart';
import 'package:grossmx/providers/cartprovider.dart';
import 'package:grossmx/providers/darkthemeprovider.dart';
import 'package:grossmx/providers/orderprovider.dart';
import 'package:grossmx/providers/productprovider.dart';
import 'package:grossmx/providers/wishlistprovider.dart';
import 'package:grossmx/views/baseview.dart';
import 'package:grossmx/views/feedview.dart';
import 'package:grossmx/views/home.dart';
import 'package:grossmx/views/onsaleview.dart';
import 'package:grossmx/views/orderview.dart';
import 'package:grossmx/views/productdetail.dart';
import 'package:grossmx/views/wishlistview.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "Your publishable Key";
  // Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  // Future __initq() = Duration()

  // final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: _firebaseInitialization,
    //     builder: (context, snapshot) {
    // if (snapshot.connectionState == ConnectionState.waiting) {
    //   return const CupertinoApp(
    //     debugShowCheckedModeBanner: false,
    //     home: CupertinoPageScaffold(
    //         child: Center(
    //       child: CupertinoActivityIndicator(),
    //     )),
    //   );
    // } else if (snapshot.hasError) {
    //   const CupertinoApp(
    //     debugShowCheckedModeBanner: false,
    //     home: CupertinoPageScaffold(
    //         child: Center(
    //       child: Text('An error occured'),
    //     )),
    //   );
    // }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => ViewedProdProvider(),
        // ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: 'grossmx',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: const BaseView(),
            routes: {
              OnSaleView.routeName: (ctx) => const OnSaleView(),
              FeedView.routeName: (ctx) => const FeedView(),
              ProductDetail.routeName: (ctx) => const ProductDetail(),
              WishlistView.routeName: (ctx) => const WishlistView(),
              OrderView.routeName: (ctx) => const OrderView(),
              // ViewedRecentlyScreen.routeName: (ctx) =>
              //     const ViewedRecentlyScreen(),
              // RegisterScreen.routeName: (ctx) => const RegisterScreen(),
              // LoginScreen.routeName: (ctx) => const LoginScreen(),
              // ForgetPasswordScreen.routeName: (ctx) =>
              //     const ForgetPasswordScreen(),
              // CategoryScreen.routeName: (ctx) => const CategoryScreen(),
            });
      }),
    );
    // });
  }
}

// class PaymentDemo extends StatelessWidget {
//   const PaymentDemo({Key? key}) : super(key: key);
//   Future<void> initPayment(
//       {required String email,
//       required double amount,
//       required BuildContext context}) async {
//     try {
//       // 1. Create a payment intent on the server
//       final response = await http.post(Uri.parse('Your function'), body: {
//         'email': email,
//         'amount': amount.toString(),
//       });

//       final jsonResponse = jsonDecode(response.body);
//       log(jsonResponse.toString());
//       // 2. Initialize the payment sheet
//       await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: jsonResponse['paymentIntent'],
//         merchantDisplayName: 'Grocery Flutter course',
//         customerId: jsonResponse['customer'],
//         customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
//         testEnv: true,
//         merchantCountryCode: 'SG',
//       ));
//       await Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Payment is successful'),
//         ),
//       );
//     } catch (errorr) {
//       if (errorr is StripeException) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured ${errorr.error.localizedMessage}'),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured $errorr'),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: ElevatedButton(
//         child: const Text('Pay 20\$'),
//         onPressed: () async {
//           await initPayment(
//               amount: 50.0, context: context, email: 'email@test.com');
//         },
//       )),
//     );
//   }
// }
