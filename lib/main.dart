import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/consts/theme_data.dart';
import 'package:project/firebase_options.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/providers/order_provider.dart';
import 'package:project/providers/product_provider.dart';
import 'package:project/providers/theme_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/providers/viewed_prod_provider.dart';
import 'package:project/providers/wishlist_provider.dart';
import 'package:project/root_screen.dart';
import 'package:project/screens/auth/forgot_password.dart';
import 'package:project/screens/auth/login.dart';
import 'package:project/screens/auth/register.dart';
import 'package:project/screens/inner_screens/orders/orders_screen.dart';
import 'package:project/screens/inner_screens/product_details.dart';
import 'package:project/screens/inner_screens/viewed_recently.dart';
import 'package:project/screens/inner_screens/wishlist.dart';
import 'package:project/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.android,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final themeProvider=Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.android),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: SelectableText(
                    "An error has been occured ${snapshot.error}"),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ProductProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Salla',
                theme: Style.themeData(
                    isDarkTheme: themeProvider.getIsDarkTheme,
                    context: context),
                home: const RootScreen(),
                routes: {
                  productDetails.routName: (context) => const productDetails(),
                  WishListScreen.routeName: (context) => const WishListScreen(),
                  ViewedRecentlyScreen.routeName: (context) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.routName: (context) => const RegisterScreen(),
                  LoginScreen.routName: (context) => const LoginScreen(),
                  OrdersScreenFree.routeName: (context) =>
                      const OrdersScreenFree(),
                  ForgotPasswordScreen.routeName: (context) =>
                      const ForgotPasswordScreen(),
                  SearchScreen.routeName: (context) => const SearchScreen(),
                  RootScreen.routName: (context) => const RootScreen(),
                },
              );
            }),
          );
        },
      ),
    );
  }
}
