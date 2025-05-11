import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'user.dart';
import 'telasAuxiliares.dart';

// TELA CONSULTAS
class ConsultaScreen extends StatelessWidget {
  final User user;
  const ConsultaScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultas"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedButton(
            context,
            label: "Realizar Consulta",
            destination: RealizarConsultaScreen(dentistaId: user.id!),
          ),
          _buildAnimatedButton(
            context,
            label: "Consultar Cliente",
            destination: ConsultarClienteScreen(dentistaId: user.id!),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, {required String label, required Widget destination}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: SizedBox(
          width: 240, // largura aumentada
          height: 45,
          child: OpenContainer(
            closedElevation: 0,
            closedColor: const Color(0xFFFFB500),
            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            closedBuilder: (context, action) => ElevatedButton(
              onPressed: action,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB500),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                label,
                style: const TextStyle(fontSize: 18), // fonte menor
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            openBuilder: (context, _) => destination,
          ),
        ),
      ),
    );
  }
}