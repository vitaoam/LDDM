import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user.dart';
import 'cliente.dart';
import 'orcamento.dart';

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
    _orcamentosFuture = DatabaseHelper.instance.getOrcamentosByDentista(
      widget.dentistaId,
    );
  }

  void _refresh() {
    setState(() {
      _orcamentosFuture = DatabaseHelper.instance.getOrcamentosByDentista(
        widget.dentistaId,
      );
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho customizado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Editar Orçamentos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // Lista de orçamentos
            Expanded(
              child: FutureBuilder<List<Orcamento>>(
                future: _orcamentosFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orcamentos = snapshot.data!;
                  if (orcamentos.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhum orçamento cadastrado.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: orcamentos.length,
                    itemBuilder: (context, index) {
                      final o = orcamentos[index];
                      return Card(
                        color: Colors.grey[850],
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            o.nome,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "R\$ ${o.valor.toStringAsFixed(2)}\n${o.descricao}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  final resultado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => EditarOrcamentoScreen(
                                            orcamento: o,
                                          ),
                                    ),
                                  );
                                  if (resultado == true) _refresh();
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () async {
                                  await DatabaseHelper.instance.deleteOrcamento(
                                    o.id!,
                                  );
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
            ),
          ],
        ),
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
    const fieldColor = Color(0xFF2E2E2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho (mantido exatamente igual)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Realizar Consulta",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Formulário (estrutura mantida, estilização refinada)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Nome
                    Text(
                      "Nome do Cliente",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nomeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          border: InputBorder.none,
                          hintText: "Digite o nome do cliente",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: amareloPrincipal.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo Telefone
                    Text(
                      "Telefone do Cliente",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _telefoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          border: InputBorder.none,
                          hintText: "Digite o telefone do cliente",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: amareloPrincipal.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Botão (mantida a lógica, estilização refinada)
                    Center(
                      child: ElevatedButton(
                        onPressed: _iniciarConsulta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: amareloPrincipal,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          elevation: 4,
                          shadowColor: amareloPrincipal.withOpacity(0.3),
                        ),
                        child: const Text(
                          "Iniciar Consulta",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
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
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho com botão de voltar e título
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Consultar Cliente",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Lista de clientes
            Expanded(
              child: FutureBuilder<List<Cliente>>(
                future: DatabaseHelper.instance.getClientesByDentista(
                  dentistaId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhum cliente cadastrado.",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  final clientes = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clientes[index];
                      return Card(
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(
                            cliente.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            cliente.telefone,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
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
            ),
          ],
        ),
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
        builder: (context) => RelatorioConsultaPage(cliente: widget.cliente),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    const amareloPrincipal = Color(0xFFF6A800);
    const backgroundColor = Color(0xFF1C1C1C);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra superior com o botão de voltar e o título (estilizada)
          Container(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(color: backgroundColor, boxShadow: [
                
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(flex: 2),
                const Text(
                  "Consulta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Conteúdo principal (mantida a estrutura, melhorada a apresentação)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.9),
                      BlendMode.modulate,
                    ),
                    child: Image.asset("assets/images/dentes.png", width: 700),
                  ),
                  const SizedBox(height: 20),

                  // Botão de gravação (estilizado)
                  ElevatedButton(
                    onPressed: _alternarGravacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          gravando ? Colors.red[700] : amareloPrincipal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 12,
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      gravando ? "PARAR GRAVAÇÃO" : "INICIAR GRAVAÇÃO",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Controles de áudio (estilizados)
                  Column(
                    children: [
                      const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 220,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 220 * 0.3, // 30% de progresso
                              decoration: BoxDecoration(
                                color: amareloPrincipal,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botão de relatório (aparece/desaparece normalmente)
                  if (mostrarBotaoRelatorio)
                    ElevatedButton(
                      onPressed: _irParaRelatorio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: amareloPrincipal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 12,
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "REVISAR RELATÓRIO",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
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
    _descricaoController = TextEditingController(
      text: widget.orcamento.descricao,
    );
    _valorController = TextEditingController(
      text: widget.orcamento.valor.toString(),
    );
  }

  void _salvarEdicao() async {
    final nome = _nomeController.text.trim();
    final descricao = _descricaoController.text.trim();
    final valor = double.tryParse(_valorController.text);

    if (nome.isEmpty || descricao.isEmpty || valor == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Campos inválidos")));
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho customizado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Editar Orçamento",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // Formulário de edição
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildTextField(_nomeController, "Nome"),
                  const SizedBox(height: 16),
                  _buildTextField(_descricaoController, "Descrição"),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _valorController,
                    "Valor (R\$)",
                    isNumber: true,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _salvarEdicao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB500),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Salvar Alterações",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class RelatorioConsultaPage extends StatelessWidget {
  final Cliente cliente;
  const RelatorioConsultaPage({super.key, required this.cliente});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
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

              // Nome do cliente
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
                'Problemas identificados:',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 10),

              // Lista de problemas
              Expanded(
                child: ListView(
                  children: [
                    _buildProblemaDente('Dente 12 - Cárie'),
                    _buildProblemaDente('Dente 22 - Fratura'),
                    _buildProblemaDente('Dente 36 - Restauração comprometida'),
                    _buildProblemaDente(
                      'Dente 45 - Necessidade de tratamento de canal',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botão Confirmar
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB500),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
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
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho estilizado
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

              // Informações do cliente
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
                  ],
                ),
              ),

              const Spacer(),

              // Botão estilizado
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
                    foregroundColor: Colors.black,
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
                  child: const Text(
                    "Checar Consultas",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
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
      backgroundColor: Colors.grey[900], // Fundo escuro
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Editar Perfil",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // Formulário
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo Nome
                      _buildTextField(
                        _nomeController,
                        "Nome",
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Email
                      _buildTextField(
                        _emailController,
                        "Email",
                        icon: Icons.email_outlined,
                        email: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          if (!value.contains('@')) return "Email inválido";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Telefone
                      _buildTextField(
                        _telefoneController,
                        "Telefone",
                        icon: Icons.phone_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo CPF
                      _buildTextField(
                        _cpfController,
                        "CPF",
                        icon: Icons.badge_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          if (!validarCPF(value)) return "CPF inválido";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo CRO
                      _buildTextField(
                        _croController,
                        "CRO",
                        icon: Icons.medical_services_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      _buildTextField(
                        _senhaController,
                        "Senha",
                        icon: Icons.lock_outline,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          if (value.length < 8) {
                            return "A senha deve ter no mínimo 8 caracteres";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Botão de Salvar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _salvarEdicao,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB500),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "Salvar Alterações",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para construir os campos de texto (atualizada com seu estilo)
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool email = false,
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        errorStyle: TextStyle(color: Colors.amber[300]),
      ),
    );
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
}
