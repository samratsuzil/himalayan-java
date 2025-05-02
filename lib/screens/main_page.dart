import 'package:flutter/material.dart';
import 'home_component.dart';
import 'saved_recipes_component.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const String routeName = '/mainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeComponentWidget(),
    SavedRecipesComponentWidget(),
    HomeComponentWidget(), // Placeholder for Save
    HomeComponentWidget(), // Placeholder for Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabIcon(String activeIcon, String inactiveIcon, int index,
      double width, double height) {
    return Image.asset(
      _selectedIndex == index ? activeIcon : inactiveIcon,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required String activeIcon,
    required String inactiveIcon,
    double iconWidth = 24,
    double iconHeight = 24,
  }) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF5F5F5) : Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: _buildTabIcon(
                  activeIcon, inactiveIcon, index, iconWidth, iconHeight),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.36,
                color: isSelected ? Colors.black : const Color(0xFFA3A3A3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _pages[_selectedIndex]),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  height: 64,
                  color: const Color(0xFFF9F9F9),
                  child: Row(
                    children: [
                      _buildNavItem(
                        index: 0,
                        label: 'Home',
                        activeIcon: 'assets/images/Home1.webp',
                        inactiveIcon: 'assets/images/home2.webp',
                      ),
                      _buildNavItem(
                        index: 1,
                        label: 'Categories',
                        activeIcon: 'assets/images/c2.webp',
                        inactiveIcon: 'assets/images/c1.webp',
                        iconWidth: 30,
                        iconHeight: 24,
                      ),
                      _buildNavItem(
                        index: 2,
                        label: 'Save',
                        activeIcon: 'assets/images/Icon1.webp',
                        inactiveIcon: 'assets/images/save2.webp',
                      ),
                      _buildNavItem(
                        index: 3,
                        label: 'Profile',
                        activeIcon: 'assets/images/pro1.webp',
                        inactiveIcon: 'assets/images/pro2.webp',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
