import 'package:flutter/material.dart';
import 'user.dart';
import 'cliente.dart';
import 'orcamento.dart';
import 'firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// TELAS AUXILIARES

class CreateBudgetScreen extends StatefulWidget {
  final String dentistaId;
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
    await FirebaseService.addOrcamento(novoOrcamento);
    Navigator.pop(context);
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com ícone de voltar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Criar Orçamento',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 32),

              // Campo Nome com ícone
              TextField(
                controller: _nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Nome do Problema",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Descrição com ícone
              TextField(
                controller: _descricaoController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Descrição do Orçamento",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Valor com ícone
              TextField(
                controller: _valorController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Valor (R\$)",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(
                    Icons.attach_money_outlined,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botão Salvar com ícone
              Center(
                child: ElevatedButton.icon(
                  onPressed: _salvarOrcamento,
                  icon: const Icon(Icons.save_outlined, color: Colors.black),
                  label: const Text(
                    "Salvar",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB500),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
    String hintText, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[700],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class EditBudgetScreen extends StatelessWidget {
  final String dentistaId; // UID do dentista logado
  const EditBudgetScreen({super.key, required this.dentistaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Orçamentos"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Orcamento>>(
        stream: FirebaseService.getOrcamentosByDentista(dentistaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum orçamento cadastrado."));
          }
          final orcamentos = snapshot.data!;
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
                  subtitle: Text(
                    "R\$ ${o.valor.toStringAsFixed(2)}\n${o.descricao}",
                    style: const TextStyle(color: Colors.white70),
                  ),
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
                          // O StreamBuilder já atualiza sozinho após edição
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await FirebaseService.deleteOrcamento(o.id!);
                          // O StreamBuilder já atualiza sozinho após exclusão
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
  final String dentistaId; // UID do dentista logado
  const RealizarConsultaScreen({super.key, required this.dentistaId});

  @override
  State<RealizarConsultaScreen> createState() => _RealizarConsultaScreenState();
}

class _RealizarConsultaScreenState extends State<RealizarConsultaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  void _iniciarConsulta() async {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
        dentistaId: widget.dentistaId,
      );
      // Salva e obtém o ID gerado pelo Firestore
      final id = await FirebaseService.addCliente(cliente);
      // Cria um novo cliente já com o ID
      final clienteComId = Cliente(
        id: id,
        nome: cliente.nome,
        telefone: cliente.telefone,
        dentistaId: cliente.dentistaId,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TelaConsultaDetalhes(cliente: clienteComId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Cliente"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome do Cliente",
                  filled: true,
                  fillColor: Colors.white24,
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Preencha este campo";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  filled: true,
                  fillColor: Colors.white24,
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Preencha este campo";
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _iniciarConsulta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB500),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Iniciar Consulta", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConsultarClienteScreen extends StatelessWidget {
  final String dentistaId; // Agora é String, o UID do Firebase Auth
  const ConsultarClienteScreen({super.key, required this.dentistaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultar Cliente"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Cliente>>(
        stream: FirebaseService.getClientesByDentista(dentistaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum cliente cadastrado."));
          }
          final clientes = snapshot.data!;
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                            DetalhesClientePage(cliente: cliente),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
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
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _textoTranscrito = "";
  String _denteExtraido = '';
  String _tratamentoExtraido = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _textoTranscrito = val.recognizedWords;
            final dados = extrairOrcamento(_textoTranscrito);
            _denteExtraido = dados['dente'] ?? '';
            _tratamentoExtraido = dados['tratamento'] ?? '';
          });
        },
        localeId: 'pt_BR',
        listenMode: stt.ListenMode.confirmation,
        partialResults: true,
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _irParaRelatorio() async {
    if (_denteExtraido.isEmpty && _tratamentoExtraido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fale o número do dente e o tratamento antes de prosseguir!")),
      );
      return;
    }

    await FirebaseService.updateClienteOrcamento(
      id: widget.cliente.id!,
      dente: _denteExtraido,
      tratamento: _tratamentoExtraido,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RelatorioConsultaPage(
          cliente: widget.cliente.copyWith(
            dente: _denteExtraido,
            tratamento: _tratamentoExtraido,
          ),
          dente: _denteExtraido,
          tratamento: _tratamentoExtraido,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta"),
        backgroundColor: const Color(0xFFFFB500),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Cliente: ${widget.cliente.nome}\nTelefone: ${widget.cliente.telefone}",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isListening ? null : _startListening,
                  icon: const Icon(Icons.mic),
                  label: const Text("Iniciar Gravação"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB500),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : null,
                  icon: const Icon(Icons.stop),
                  label: const Text("Parar Gravação"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _textoTranscrito.isEmpty
                        ? "Fale, por exemplo: 'Dente 12 restauração'"
                        : _textoTranscrito,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  if (_denteExtraido.isNotEmpty)
                    Text("Dente: $_denteExtraido", style: const TextStyle(color: Colors.white70)),
                  if (_tratamentoExtraido.isNotEmpty)
                    Text("Tratamento: $_tratamentoExtraido", style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _irParaRelatorio,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Finalizar e ver consulta"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB500),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
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

    await FirebaseService.updateOrcamento(orcamentoEditado);

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
  final String dente;
  final String tratamento;

  const RelatorioConsultaPage({
    super.key,
    required this.cliente,
    required this.dente,
    required this.tratamento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Relatório da Consulta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                cliente.nome,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Orçamento Identificado:',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 10),
              _buildOrcamentoInfo("Dente", dente),
              _buildOrcamentoInfo("Tratamento", tratamento),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB500),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrcamentoInfo(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$label: $value",
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
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Detalhes do Cliente',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nome:',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cliente.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Telefone:',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cliente.telefone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Orçamento Identificado:',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    if ((cliente.dente ?? '').isNotEmpty)
                      Text("Dente: ${cliente.dente}", style: const TextStyle(color: Colors.white)),
                    if ((cliente.tratamento ?? '').isNotEmpty)
                      Text("Tratamento: ${cliente.tratamento}", style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Excluir Cliente"),
                        content: const Text("Tem certeza que deseja excluir este cliente?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await FirebaseService.deleteCliente(cliente.id!);
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Excluir Cliente"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(220, 50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _cpfController;
  late TextEditingController _croController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.user.nome);
    _emailController = TextEditingController(text: widget.user.email);
    _telefoneController = TextEditingController(text: widget.user.telefone);
    _cpfController = TextEditingController(text: widget.user.cpf);
    _croController = TextEditingController(text: widget.user.cro);
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
      );
      await FirebaseService.updateUser(userEditado);
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
              const SizedBox(height: 32),
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

Map<String, String> extrairOrcamento(String texto) {
  final denteRegex = RegExp(r'dente\s*(\d{1,2})', caseSensitive: false);
  final tratamentoRegex = RegExp(
    r'restauração|canal|extração|limpeza|cárie|fratura',
    caseSensitive: false,
  );

  final denteMatch = denteRegex.firstMatch(texto);
  final tratamentoMatch = tratamentoRegex.firstMatch(texto);

  return {
    'dente': denteMatch != null ? denteMatch.group(1)! : '',
    'tratamento': tratamentoMatch != null ? tratamentoMatch.group(0)! : '',
  };
}

bool validarCPF(String cpf) {
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  if (cpf.length != 11) return false;
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

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