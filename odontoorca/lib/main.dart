import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:animations/animations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'database_helper.dart';
import 'user.dart';
import 'cliente.dart';
import 'orcamento.dart';

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
        scaffoldBackgroundColor: const Color(0xFF2D2D2D),
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
      backgroundColor: const Color(0xFF2D2D2D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/sven.jpeg'),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
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
                  MaterialPageRoute(builder: (context) => const CadastroScreen()),
                );
              },
              child: const Text("Cadastrar", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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

//TELA PRINCIPAL
class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  void initState(){
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
              title: const Text("Consultas", style: TextStyle(color: Colors.white)),
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

// TELA ORÇAMENTOS
class CartScreen extends StatelessWidget {
  final User user;
  const CartScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orçamentos"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildAnimatedButton(BuildContext context, {required String label, required Widget destination}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: SizedBox(
          width: 240,
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
                style: const TextStyle(fontSize: 18),
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

//TELA DE LOGIN
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool isLoginConfirmed = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: const Text("Login"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 70.0),
              const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 280.0,
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: 280.0,
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Senha",
                    hintStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Checkbox(
                      value: rememberMe,
                      fillColor:
                      WidgetStateProperty.all<Color>(Colors.white),
                      checkColor: const Color(0xFFFFB500),
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                  ),
                  const Text(
                    "Lembrar de mim.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              MaterialButton(
                onPressed: () async {
                  final user = await DatabaseHelper.instance.getUserByEmailAndPassword(
                    emailController.text,
                    passwordController.text,
                  );
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Email ou senha inválidos")),
                    );
                  }
                },
                color: const Color(0xFFFFB500),
                child: const Text(
                  "Entrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
  
// TELA PERFIL
class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileScreen(user: result)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
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

// TELAS AUXILIARES

class CreateBudgetScreen extends StatefulWidget {
  final int dentistaId;
  const CreateBudgetScreen({super.key, required this.dentistaId});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  void _salvarOrcamento() async {
    String nome = _nomeController.text.trim();
    String descricao = _descricaoController.text.trim();
    double? valor = double.tryParse(_valorController.text);

    if (nome.isEmpty || descricao.isEmpty || valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    final novoOrcamento = Orcamento(
      nome: nome,
      descricao: descricao,
      valor: valor,
      dentistaId: widget.dentistaId,
    );
    await DatabaseHelper.instance.insertOrcamento(novoOrcamento);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Orçamento"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField(_nomeController, "Nome do Paciente"),
            const SizedBox(height: 16),
            _buildTextField(_descricaoController, "Descrição do Orçamento"),
            const SizedBox(height: 16),
            _buildTextField(_valorController, "Valor (R\$)", isNumber: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _salvarOrcamento,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB500),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Salvar",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[700],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
    );
  }
}

class EditBudgetScreen extends StatefulWidget {
  final int dentistaId;
  const EditBudgetScreen({super.key, required this.dentistaId});

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  late Future<List<Orcamento>> _orcamentosFuture;

  @override
  void initState() {
    super.initState();
    _orcamentosFuture = DatabaseHelper.instance.getOrcamentosByDentista(widget.dentistaId);
  }

  void _refresh() {
    setState(() {
      _orcamentosFuture = DatabaseHelper.instance.getOrcamentosByDentista(widget.dentistaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Orçamentos"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Orcamento>>(
        future: _orcamentosFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final orcamentos = snapshot.data!;
          if (orcamentos.isEmpty) return const Center(child: Text("Nenhum orçamento cadastrado."));
          return ListView.builder(
            itemCount: orcamentos.length,
            itemBuilder: (context, index) {
              final o = orcamentos[index];
              return Card(
                color: Colors.grey[850],
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(o.nome, style: const TextStyle(color: Colors.white)),
                  subtitle: Text("R\$ ${o.valor.toStringAsFixed(2)}\n${o.descricao}", style: const TextStyle(color: Colors.white70)),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () async {
                          final resultado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarOrcamentoScreen(orcamento: o),
                            ),
                          );
                          if (resultado == true) _refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteOrcamento(o.id!);
                          _refresh();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RealizarConsultaScreen extends StatefulWidget {
  final int dentistaId;
  const RealizarConsultaScreen({super.key, required this.dentistaId});

  @override
  State<RealizarConsultaScreen> createState() => _RealizarConsultaScreenState();
}

class _RealizarConsultaScreenState extends State<RealizarConsultaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  void _iniciarConsulta() async {
    final nomeCliente = _nomeController.text.trim();
    final telefoneCliente = _telefoneController.text.trim();

    if (nomeCliente.isEmpty || telefoneCliente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    // Adiciona o cliente à lista global
    final novoCliente = Cliente(
      nome: nomeCliente,
      telefone: telefoneCliente,
      dentistaId: widget.dentistaId,
    );
    final idCliente = await DatabaseHelper.instance.insertCliente(novoCliente);

// Recupere o cliente recém-criado do banco (com id correto)
    final clienteSalvo = Cliente(
      id: idCliente,
      nome: nomeCliente,
      telefone: telefoneCliente,
      dentistaId: widget.dentistaId,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaConsultaDetalhes(cliente: clienteSalvo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1C1C1C);
    const amareloPrincipal = Color(0xFFF6A800);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: amareloPrincipal,
        centerTitle: true,
        title: const Text(
          "Realizar Consulta",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nome do Cliente",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: InputBorder.none,
                  hintText: "Digite o nome do cliente",
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Telefone do Cliente",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: InputBorder.none,
                  hintText: "Digite o telefone do cliente",
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _iniciarConsulta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: amareloPrincipal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text(
                  "Iniciar Consulta",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultarClienteScreen extends StatelessWidget {
  final int dentistaId;
  const ConsultarClienteScreen({super.key, required this.dentistaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultar Cliente"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Cliente>>(
        future: DatabaseHelper.instance.getClientesByDentista(dentistaId),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const CircularProgressIndicator();
          }
          final clientes = snapshot.data!;
          if(clientes.isEmpty){
            return const Text("Nenhum cliente cadastrado.");
          }
          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(cliente.nome),
                  subtitle: Text(cliente.telefone),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: (){
                    Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => DetalhesClientePage(cliente: cliente)), 
                    );
                  }
                )
              );
            }
          );
        }
      )
    );
  }
}

class TelaConsultaDetalhes extends StatefulWidget {
  final Cliente cliente;
  const TelaConsultaDetalhes({super.key, required this.cliente});

  @override
  State<TelaConsultaDetalhes> createState() => _TelaConsultaDetalhesState();
}

class _TelaConsultaDetalhesState extends State<TelaConsultaDetalhes> {
  bool gravando = false;
  bool mostrarBotaoRelatorio = false;

  void _alternarGravacao() {
    setState(() {
      gravando = !gravando;
      if (!gravando) {
        mostrarBotaoRelatorio = true;
      }
    });

    //logica mais tarde
  }

  void _irParaRelatorio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RelatorioConsultaPage(
          cliente: widget.cliente,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const amareloPrincipal = Color(0xFFF6A800);
    const backgroundColor = Color(0xFF1C1C1C);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: amareloPrincipal,
        title: const Text("Consulta", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset("assets/images/dentes.png", width: 700),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _alternarGravacao,
              style: ElevatedButton.styleFrom(
                backgroundColor: amareloPrincipal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: Text(
                gravando ? "Parar Gravação" : "Iniciar Gravação",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.play_arrow, color: Colors.white),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 10,
              color: Colors.white,
              child: const Row(
                children: [
                  Expanded(child: Divider(color: Colors.black, thickness: 2)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (mostrarBotaoRelatorio)
              ElevatedButton(
                onPressed: _irParaRelatorio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: amareloPrincipal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: const Text("Revisar Relatório", style: TextStyle(fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}

class EditarOrcamentoScreen extends StatefulWidget {
  final Orcamento orcamento;

  const EditarOrcamentoScreen({super.key, required this.orcamento});

  @override
  State<EditarOrcamentoScreen> createState() => _EditarOrcamentoScreenState();
}

class _EditarOrcamentoScreenState extends State<EditarOrcamentoScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.orcamento.nome);
    _descricaoController = TextEditingController(text: widget.orcamento.descricao);
    _valorController = TextEditingController(text: widget.orcamento.valor.toString());
  }

  void _salvarEdicao() async {
    final nome = _nomeController.text.trim();
    final descricao = _descricaoController.text.trim();
    final valor = double.tryParse(_valorController.text);

    if (nome.isEmpty || descricao.isEmpty || valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Campos inválidos")),
      );
      return;
    }

    final orcamentoEditado = Orcamento(
      id: widget.orcamento.id,
      nome: nome,
      descricao: descricao,
      valor: valor,
      dentistaId: widget.orcamento.dentistaId,
    );

    await DatabaseHelper.instance.updateOrcamento(orcamentoEditado);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Orçamento"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField(_nomeController, "Nome"),
            const SizedBox(height: 16),
            _buildTextField(_descricaoController, "Descrição"),
            const SizedBox(height: 16),
            _buildTextField(_valorController, "Valor (R\$)", isNumber: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _salvarEdicao,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB500),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Salvar Alterações",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[700],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
    );
  }
}

class RelatorioConsultaPage extends StatelessWidget {
  final Cliente cliente;
  const RelatorioConsultaPage({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        title: Text('Relatório da Consulta', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFFB500),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cliente.nome,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Problemas identificados:',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildProblemaDente('Dente 12 - Cárie'),
                  _buildProblemaDente('Dente 22 - Fratura'),
                  _buildProblemaDente('Dente 36 - Restauração comprometida'),
                  _buildProblemaDente('Dente 45 - Necessidade de tratamento de canal'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB500),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemaDente(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class DetalhesClientePage extends StatelessWidget {
  final Cliente cliente;

  const DetalhesClientePage({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        title: Text('Detalhes do Cliente', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFFB500),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome:', style: TextStyle(color: Colors.white70, fontSize: 16)),
            Text(cliente.nome, style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 20),
            Text('Telefone:', style: TextStyle(color: Colors.white70, fontSize: 16)),
            Text(cliente.telefone, style: TextStyle(color: Colors.white, fontSize: 20)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RelatorioConsultaPage(cliente: cliente),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB500),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Checar consultas",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _cpfController;
  late TextEditingController _croController;
  late TextEditingController _senhaController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.user.nome);
    _emailController = TextEditingController(text: widget.user.email);
    _telefoneController = TextEditingController(text: widget.user.telefone);
    _cpfController = TextEditingController(text: widget.user.cpf);
    _croController = TextEditingController(text: widget.user.cro);
    _senhaController = TextEditingController(text: widget.user.senha);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _croController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _salvarEdicao() async {
    if (_formKey.currentState!.validate()) {
      final userEditado = User(
        id: widget.user.id,
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        cpf: _cpfController.text.trim(),
        cro: _croController.text.trim(),
        senha: _senhaController.text.trim(),
      );
      await DatabaseHelper.instance.updateUser(userEditado);
      Navigator.pop(context, userEditado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nomeController, "Nome", validator: (value) {
                if (value == null || value.trim().isEmpty) return "Preencha este campo";
                return null;
              }),
              const SizedBox(height: 12),
              _buildTextField(_emailController, "Email", email: true, validator: (value) {
                if (value == null || value.trim().isEmpty) return "Preencha este campo";
                if (!value.contains('@')) return "Email inválido";
                return null;
              }),
              const SizedBox(height: 12),
              _buildTextField(_telefoneController, "Telefone", validator: (value) {
                if (value == null || value.trim().isEmpty) return "Preencha este campo";
                return null;
              }),
              const SizedBox(height: 12),
              _buildTextField(_cpfController, "CPF", validator: (value) {
                if (value == null || value.trim().isEmpty) return "Preencha este campo";
                if (!validarCPF(value)) return "CPF inválido";
                return null;
              }),
              const SizedBox(height: 12),
              _buildTextField(_croController, "CRO", validator: (value) {
                if (value == null || value.trim().isEmpty) return "Preencha este campo";
                return null;
              }),
              const SizedBox(height: 12),
              _buildTextField(_senhaController, "Senha", obscure: true, validator: (value) {
                if (value == null || value.trim().isEmpty) return "Preencha este campo";
                if (value.length < 8) return "A senha deve ter no mínimo 8 caracteres";
                return null;
              }),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarEdicao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB500),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Salvar Alterações",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        bool email = false,
        bool obscure = false,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
    );
  }

}

bool validarCPF(String cpf) {
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  if (cpf.length != 11) return false;
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

  // Validação dos dígitos verificadores
  List<int> numbers = cpf.split('').map(int.parse).toList();

  int soma = 0;
  for (int i = 0; i < 9; i++) {
    soma += numbers[i] * (10 - i);
  }
  int primeiroDigito = 11 - (soma % 11);
  if (primeiroDigito >= 10) primeiroDigito = 0;
  if (numbers[9] != primeiroDigito) return false;

  soma = 0;
  for (int i = 0; i < 10; i++) {
    soma += numbers[i] * (11 - i);
  }
  int segundoDigito = 11 - (soma % 11);
  if (segundoDigito >= 10) segundoDigito = 0;
  if (numbers[10] != segundoDigito) return false;

  return true;
}
