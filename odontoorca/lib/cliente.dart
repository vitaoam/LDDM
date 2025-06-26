class Cliente {
  final String? id;
  final String nome;
  final String telefone;
  final String dentistaId;
  final String? dente;
  final String? tratamento;

  Cliente({
    this.id,
    required this.nome,
    required this.telefone,
    required this.dentistaId,
    this.dente,
    this.tratamento,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'dentista_id': dentistaId,
      'dente': dente,
      'tratamento': tratamento,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map, String id) {
    return Cliente(
      id: id,
      nome: map['nome'],
      telefone: map['telefone'],
      dentistaId: map['dentista_id'],
      dente: map['dente'],
      tratamento: map['tratamento'],
    );
  }

  Cliente copyWith({
    String? dente,
    String? tratamento,
  }) {
    return Cliente(
      id: id,
      nome: nome,
      telefone: telefone,
      dentistaId: dentistaId,
      dente: dente ?? this.dente,
      tratamento: tratamento ?? this.tratamento,
    );
  }
}
