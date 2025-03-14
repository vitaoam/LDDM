import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OdontoOrça',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF2D2D2D),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/sven.jpeg'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB500),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text("Entrar", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
            ),
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
              title: const Text("Home", style: TextStyle(color: Colors.white)),
              selectedColor: const Color(0xFFFFB500),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.attach_money, color: Colors.white),
              title: const Text("Orçamentos", style: TextStyle(color: Colors.white)),
              selectedColor: const Color(0xFFFFB500),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person, color: Colors.white),
              title: const Text("Perfil", style: TextStyle(color: Colors.white)),
              selectedColor: const Color(0xFFFFB500),
            ),
          ],
        ),
      ),
    );
  }
}

// Conteúdo da Home
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Página Inicial", style: TextStyle(fontSize: 24, color: Colors.white)),
    );
  }
}

// Tela do Carrinho (Orçamentos)
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Orçamentos", style: TextStyle(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 20),
          OpenContainer(
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            closedBuilder: (context, action) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB500),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: action,
              child: const Text("Criar Orçamento", style: TextStyle(fontSize: 18)),
            ),
            openBuilder: (context, action) => const CreateBudgetScreen(),
          ),
          const SizedBox(height: 10),
          OpenContainer(
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            closedBuilder: (context, action) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB500),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: action,
              child: const Text("Editar Orçamento", style: TextStyle(fontSize: 18)),
            ),
            openBuilder: (context, action) => const EditBudgetScreen(),
          ),
        ],
      ),
    );
  }
}

// Tela Criar Orçamento
class CreateBudgetScreen extends StatelessWidget {
  const CreateBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Orçamento"),
        backgroundColor: const Color(0xFFFFB500),
      ),
      body: const Center(
        child: Text("Tela de Criação de Orçamento", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}

// Tela Editar Orçamento
class EditBudgetScreen extends StatelessWidget {
  const EditBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Orçamento"),
        backgroundColor: const Color(0xFFFFB500),
      ),
      body: const Center(
        child: Text("Tela de Edição de Orçamento", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}

// Tela de Perfil com Botão de Logout
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Perfil", style: TextStyle(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB500),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            child: const Text("Logout", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
