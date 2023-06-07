import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/screens/home/shops.dart';
import 'package:mammi/services/auth.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../dashboard/userProductPage.dart';
import '../settings/settings.dart';
import 'food/food_page.dart';
import 'order/cart_page.dart';
import 'order/user_order.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isRefreshing = false;

  final List<Widget> _widgetOptions = <Widget>[
    const FoodPage(),
    const OrdersPage(),
    const CartPage(),
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate a delay to show the refresh indicator
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    final AuthService auth = AuthService();

    /// Open the dashboard page
    void openDashboard() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProductsPage(userId: user.uid)),
      );
    }

    /// Open the orders page
    void openOrdersPage() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrdersPage(),
        ),
      );
    }

    /// Open the orders page
    void openOrders() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrdersPage(),
        ),
      );
    }

    return StreamProvider<List<Product>?>.value(
      value: DatabaseService(user.uid).products,
      initialData: null,
      builder: (context, snapshot) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.money_off_csred_sharp),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.mainColor,
            onTap: _onItemTapped,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppColors.mainColor,
                  ),
                  child: Text(
                    'USER ID: ${user.uid}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Dashboard'),
                  onTap: () {
                    openDashboard();
                  },
                ),
                ListTile(
                  title: const Text('Orders'),
                  onTap: () {
                    openOrdersPage();
                  },
                ),
                // ListTile(
                //   title: const Text('Settings'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const SettingsPage()),
                //     );
                //   },
                // ),
                ListTile(
                  title: const Text('Log Out'),
                  onTap: () async {
                    await auth.signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
