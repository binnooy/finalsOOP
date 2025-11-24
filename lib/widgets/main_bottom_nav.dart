import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import '../screens/add_transaction.dart';
import '../screens/history_reports.dart';
import '../screens/categories.dart';
import '../screens/more.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({Key? key}) : super(key: key);

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int _currentIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const DashboardScreen(),
    const AddTransactionScreen(),
    const HistoryReportsScreen(),
    const CategoriesScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
