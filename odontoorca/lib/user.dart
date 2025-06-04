class User {
  final String? id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String cro;

  User({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.cro,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'cro': cro,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      cpf: map['cpf'],
      cro: map['cro'],
    );
  }
}
