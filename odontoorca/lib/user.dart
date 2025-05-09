class User {
  final int? id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String cro;
  final String senha;

  User({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.cro,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'cro': cro,
      'senha': senha,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      cpf: map['cpf'],
      cro: map['cro'],
      senha: map['senha'],
    );
  }
}

