class Cliente {
  final int? id;
  final String nome;
  final String telefone;
  final int dentistaId;

  Cliente({
    this.id,
    required this.nome,
    required this.telefone,
    required this.dentistaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'dentista_id': dentistaId,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      dentistaId: map['dentista_id'],
    );
  }
}
