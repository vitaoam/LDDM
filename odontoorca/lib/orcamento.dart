class Orcamento {
  final String? id;
  final String nome;
  final String descricao;
  final double valor;
  final String dentistaId;

  Orcamento({
    this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.dentistaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'dentista_id': dentistaId,
    };
  }

  factory Orcamento.fromMap(Map<String, dynamic> map, String id) {
    return Orcamento(
      id: id,
      nome: map['nome'],
      descricao: map['descricao'],
      valor: (map['valor'] as num).toDouble(),
      dentistaId: map['dentista_id'],
    );
  }
}
