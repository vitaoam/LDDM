import 'package:flutter/material.dart';
import 'user.dart';
import 'main.dart';
import 'telasAuxiliares.dart';
import 'firebase_service.dart';

// TELA PERFIL
class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = FirebaseService.getUserById(widget.user.id!);
  }

  void _refreshUser() {
    setState(() {
      _userFuture = FirebaseService.getUserById(widget.user.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Perfil do Dentista"),
            backgroundColor: const Color(0xFFFFB500),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: "Sair",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 60, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                _profileField("Nome", user.nome),
                _profileField("Email", user.email),
                _profileField("Telefone", user.telefone),
                _profileField("CPF", user.cpf),
                _profileField("CRO", user.cro),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text("Editar Perfil", style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB500),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(user: user),
                        ),
                      );
                      if (result is User) {
                        _refreshUser();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Perfil atualizado com sucesso!")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
