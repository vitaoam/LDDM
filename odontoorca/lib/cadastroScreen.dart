import 'package:flutter/material.dart';
import 'user.dart';
import 'main.dart';
import 'loginScreen.dart';
import 'telasAuxiliares.dart';
import 'firebase_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({Key? key}) : super(key: key);

  @override
  CadastroScreenState createState() => CadastroScreenState();
}

class CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  bool preencheu = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController croController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botão de voltar
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Cadastro",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFB500),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: _inputDecoration("Nome"),
                      validator:
                          (value) =>
                              (value?.isEmpty ?? true)
                                  ? 'Escreva seu nome'
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(fontSize: 18),
                      decoration: _inputDecoration("Email"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Preencha este campo";
                        }
                        if (!value.contains('@')) return "Email inválido";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18),
                      decoration: _inputDecoration("Telefone"),
                      validator:
                          (value) =>
                              (value?.isEmpty ?? true)
                                  ? 'Escreva seu telefone'
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: cpfController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("CPF"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Preencha este campo";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: croController,
                      style: const TextStyle(fontSize: 18),
                      decoration: _inputDecoration("CRO"),
                      validator:
                          (value) =>
                              (value?.isEmpty ?? true)
                                  ? 'Escreva seu CRO'
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(fontSize: 18),
                      decoration: _inputDecoration("Senha"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Escreva a senha';
                        }
                        if (value.length < 8) {
                          return 'A senha deve ter no mínimo 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final user = User(
                            nome: nameController.text,
                            email: emailController.text,
                            telefone: phoneController.text,
                            cpf: cpfController.text,
                            cro: croController.text,
                          );
                          await FirebaseService.signUp(user, passwordController.text);
                          setState(() => preencheu = true);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                        } else {
                          setState(() => preencheu = false);
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text(
                                    "Precisa preencher os dados",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Ok"),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        foregroundColor: const Color(0xFFFFB500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                          side: const BorderSide(color: Color(0xFFFFB500)),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Próximo',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white24,
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16, // Tamanho padrão do label
      ),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFFFFB500),
        fontSize: 18, // Quando clica no campo
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
