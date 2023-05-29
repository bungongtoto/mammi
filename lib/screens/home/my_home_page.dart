import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/screens/home/main_food_page.dart';
import 'package:mammi/screens/others/add_product.dart';
import 'package:mammi/services/auth.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  
      
    

  int _selectedIndex = 0;

  final  List<Widget> _widgetOptions = <Widget>[
    const MainFoodPage(),
     
    // ThirdPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openAddProductPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }

  

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserApp>(context);
    final AuthService auth = AuthService();
    
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
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
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
              title: const Text('ADD FOOD FOR SALE'),
              onTap: () {
                _openAddProductPage();
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
}

