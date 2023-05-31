import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/screens/home/cart.dart';
import 'package:mammi/screens/home/shops.dart';
import 'package:mammi/services/auth.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../dashboard/userProductPage.dart';
import 'food/food_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  final  List<Widget> _widgetOptions = <Widget> [
    const FoodPage(),
    const ShopsPage(),
    const CartPage(),     
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserApp>(context);
    final AuthService auth = AuthService();

    void openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProductsPage(userId:user.uid)),
    );
  }
    
    return StreamProvider<List<Product>?>.value(
      value: DatabaseService(user.uid).products, 
      initialData: null,
      builder: (context, snapshot) {
        return Scaffold( 
        
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: 'shops',
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
          drawer:  Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                   DrawerHeader(
                  decoration:const BoxDecoration(
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
                  title: const Text('Option 2'),
                  onTap: () {
                    // Perform action
                  },
                ),
                ListTile(
                  
                  title: const Text('Log Out'),
                  
                  onTap: () async{
      
                    await auth.signOut();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

