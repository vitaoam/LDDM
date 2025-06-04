class Cliente {
  final String? id;
  final String nome;
  final String telefone;
  final String dentistaId;

  Cliente({
    this.id,
    required this.nome,
    required this.telefone,
    required this.dentistaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'dentista_id': dentistaId,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map, String id) {
    return Cliente(
      id: id,
      nome: map['nome'],
      telefone: map['telefone'],
      dentistaId: map['dentista_id'],
    );
  }
}
