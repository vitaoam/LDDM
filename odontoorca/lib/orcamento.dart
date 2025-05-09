class Orcamento {
  final int? id;
  final String nome;
  final String descricao;
  final double valor;
  final int dentistaId;

  Orcamento({
    this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.dentistaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'dentista_id': dentistaId,
    };
  }

  factory Orcamento.fromMap(Map<String, dynamic> map) {
    return Orcamento(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      valor: map['valor'] is int ? (map['valor'] as int).toDouble() : map['valor'],
      dentistaId: map['dentista_id'],
    );
  }
}
