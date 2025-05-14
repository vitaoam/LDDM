import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';
import 'cliente.dart';
import 'orcamento.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT,
        telefone TEXT,
        cpf TEXT,
        cro TEXT,
        senha TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE clientes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        telefone TEXT,
        dentista_id INTEGER,
        FOREIGN KEY(dentista_id) REFERENCES users(id)
      )
    ''');
    await db.execute('''
    CREATE TABLE orcamentos(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      descricao TEXT,
      valor REAL,
      dentista_id INTEGER,
      FOREIGN KEY(dentista_id) REFERENCES users(id)
    )
  ''');
  }

  // Usuário
  Future<int> insertUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmailAndPassword(String email, String senha) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User> getUserById(int id) async{
    final db = await instance.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if(maps.isNotEmpty){
      return User.fromMap(maps.first);
    }
    throw Exception('Usuario não encontrado');
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cliente
  Future<int> insertCliente(Cliente cliente) async {
    final db = await instance.database;
    return await db.insert('clientes', cliente.toMap());
  }

  Future<List<Cliente>> getClientesByDentista(int dentistaId) async {
    final db = await instance.database;
    final maps = await db.query(
      'clientes',
      where: 'dentista_id = ?',
      whereArgs: [dentistaId],
    );
    return maps.map((map) => Cliente.fromMap(map)).toList();
  }
  // Inserir orçamento
  Future<int> insertOrcamento(Orcamento orcamento) async {
    final db = await instance.database;
    return await db.insert('orcamentos', orcamento.toMap());
  }

// Buscar orçamentos do dentista
  Future<List<Orcamento>> getOrcamentosByDentista(int dentistaId) async {
    final db = await instance.database;
    final maps = await db.query(
      'orcamentos',
      where: 'dentista_id = ?',
      whereArgs: [dentistaId],
    );
    return maps.map((map) => Orcamento.fromMap(map)).toList();
  }

// Atualizar orçamento
  Future<int> updateOrcamento(Orcamento orcamento) async {
    final db = await instance.database;
    return await db.update(
      'orcamentos',
      orcamento.toMap(),
      where: 'id = ?',
      whereArgs: [orcamento.id],
    );
  }

// Deletar orçamento
  Future<int> deleteOrcamento(int id) async {
    final db = await instance.database;
    return await db.delete(
      'orcamentos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
