import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user.dart';
import 'main.dart';
import 'loginScreen.dart';
import 'telasAuxiliares.dart';

//TELA DE CADASTRO
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          },
        ),
        title: const Text("Cadastro"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 150.0),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: 'Nome',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Escreva seu nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Preencha este campo";
                        if (!value.contains('@')) return "Email inválido";
                        return null;
                      },

                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: 'Telefone',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Escreva seu telefone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: cpfController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: 'CPF',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Preencha este campo";
                        if (!validarCPF(value)) return "CPF inválido";
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: croController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: 'CRO',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Escreva seu CRO';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        labelText: 'Senha',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      obscureText: true,
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
                    const SizedBox(height: 40.0),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final user = User(
                            nome: nameController.text,
                            email: emailController.text,
                            telefone: phoneController.text,
                            cpf: cpfController.text,
                            cro: croController.text,
                            senha: passwordController.text,
                          );
                          await DatabaseHelper.instance.insertUser(user);
                          setState(() {
                            preencheu = true;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        } else {
                          setState(() {
                            preencheu = false;
                          });
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Precisa preencher os dados"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Ok"),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFFFB500)),
                      ),
                      child: const Text('Próximo'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}