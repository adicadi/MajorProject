import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:planto/Model/cart.dart';
import 'package:planto/Model/diseaseProvider.dart';
import 'package:planto/Model/orders.dart';
import 'package:planto/Model/product_provider.dart';
import 'package:planto/screens/cart_screen.dart';
import 'package:planto/screens/edit_product_screen.dart';
import 'package:planto/screens/home.dart';
import 'package:planto/screens/marketScreen.dart';
import 'package:planto/screens/orders_screen.dart';
import 'package:planto/screens/product_detail.dart';
import 'package:planto/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Disease()),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              bodyText1: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: HexColor('#031D07'))),
        title: 'plantO',
        home: /* AnimatedSplashScreen(
          splashIconSize: 900,
          splash: Splash(),
          backgroundColor: HexColor('#031D07'),
          splashTransition: SplashTransition.scaleTransition,
          nextScreen:  */
            Home(),
        routes: {
          MarketScreen.routeName: (context) => MarketScreen(),
          ProductDetail.routeName: (context) => ProductDetail(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
        //),
      ),
    );
  }
}
