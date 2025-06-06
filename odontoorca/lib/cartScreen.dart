import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'user.dart';
import 'telasAuxiliares.dart';

// TELA ORÇAMENTOS
class CartScreen extends StatelessWidget {
  final User user;
  const CartScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: const [
                Icon(Icons.attach_money, color: Color(0xFFFFB500)),
                SizedBox(width: 10),
                Text(
                  "Orçamentos",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Gerencie seus orçamentos de forma rápida e fácil.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                _buildAnimatedButton(
                  context,
                  label: "Criar Orçamento",
                  destination: CreateBudgetScreen(dentistaId: user.id!),
                ),
                _buildAnimatedButton(
                  context,
                  label: "Editar Orçamento",
                  destination: EditBudgetScreen(dentistaId: user.id!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildAnimatedButton(
    BuildContext context, {
    required String label,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 240,
        height: 48,
        child: OpenContainer(
          closedElevation: 0,
          closedColor: const Color(0xFFFFB500),
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          closedBuilder:
              (context, action) => ElevatedButton(
                onPressed: action,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB500),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          openBuilder: (context, _) => destination,
        ),
      ),
    );
  }
}
