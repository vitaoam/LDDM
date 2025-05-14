import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:animations/animations.dart';
import 'user.dart';
import 'consultaScreen.dart';
import 'cartScreen.dart';
import 'profileScreen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ConsultaScreen(user: widget.user),
      CartScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            child: Row(
              children: [
                const Icon(Icons.waving_hand, color: Color(0xFFFFB500)),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Bem-vindo, ${widget.user.nome}!',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(
            color: Colors.white12,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
          ],
        ),
        child: SalomonBottomBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home, color: Colors.white),
              title: const Text(
                "Consultas",
                style: TextStyle(color: Colors.white),
              ),
              selectedColor: const Color(0xFFFFB500),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.attach_money, color: Colors.white),
              title: const Text(
                "Orçamentos",
                style: TextStyle(color: Colors.white),
              ),
              selectedColor: const Color(0xFFFFB500),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                "Perfil",
                style: TextStyle(color: Colors.white),
              ),
              selectedColor: const Color(0xFFFFB500),
            ),
          ],
        ),
      ),
    );
  }
}
