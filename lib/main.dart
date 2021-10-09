import 'package:buy_it/constants.dart';
import 'package:buy_it/provider/admin_mode.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:buy_it/provider/modalHud.dart';
import 'package:buy_it/screens/admin/addProduct_screen.dart';
import 'package:buy_it/screens/admin/adminHome_screen.dart';
import 'package:buy_it/screens/admin/editProduct_screen.dart';
import 'package:buy_it/screens/admin/manageProducts_screen.dart';
import 'package:buy_it/screens/admin/orderDetails_screen.dart';
import 'package:buy_it/screens/admin/order_screen.dart';
import 'package:buy_it/screens/user/cart_screen.dart';
import 'package:buy_it/screens/user/homepage_screen.dart';
import 'package:buy_it/screens/user/login_screen.dart';
import 'package:buy_it/screens/user/productInfo_screen.dart';
import 'package:buy_it/screens/user/signup_screen.dart';
import 'package:buy_it/screens/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BuyItApp());
}

class BuyItApp extends StatelessWidget {
  bool isLoggedIn;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoadingScreen();

        isLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ModalHud>(create: (context) => ModalHud()),
            ChangeNotifierProvider<AdminMode>(create: (context) => AdminMode()),
            ChangeNotifierProvider<CartItem>(create: (context) => CartItem()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              unselectedWidgetColor: Colors.white,
              accentColor: kMainColor,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  elevation: 4,
                ),
              ),
              textTheme: TextTheme(
                button: TextStyle(color: Colors.white),
              ),
            ),
            initialRoute:
                isLoggedIn == null ? LogInScreen.id : HomePageScreen.id,
            routes: {
              LogInScreen.id: (context) => LogInScreen(),
              SignUpScreen.id: (context) => SignUpScreen(),
              AdminHomeScreen.id: (context) => AdminHomeScreen(),
              AddProductScreen.id: (context) => AddProductScreen(),
              ManageProductsScreen.id: (context) => ManageProductsScreen(),
              EditProductScreen.id: (context) => EditProductScreen(),
              OrderScreen.id: (context) => OrderScreen(),
              OrderDetailsScreen.id: (context) => OrderDetailsScreen(),
              HomePageScreen.id: (context) => HomePageScreen(),
              ProductInfoScreen.id: (context) => ProductInfoScreen(),
              CartScreen.id: (context) => CartScreen(),
            },
          ),
        );
      },
    );
  }
}
