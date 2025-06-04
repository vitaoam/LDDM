import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'user.dart';
import 'cliente.dart';
import 'orcamento.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = fb_auth.FirebaseAuth.instance;

  // Auth
  static Future<fb_auth.User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  static Future<fb_auth.User?> signUp(User user, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: user.email, password: password);
    await _firestore.collection('users').doc(cred.user!.uid).set(user.toMap());
    return cred.user;
  }

  static Future<User?> getUserById(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  static Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  // Clientes
  static Future<void> addCliente(Cliente cliente) async {
    await _firestore.collection('clientes').add(cliente.toMap());
  }

  static Stream<List<Cliente>> getClientesByDentista(String dentistaId) {
    return _firestore
        .collection('clientes')
        .where('dentista_id', isEqualTo: dentistaId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Cliente.fromMap(doc.data(), doc.id)).toList());
  }

  // Orçamentos
  static Future<void> addOrcamento(Orcamento orcamento) async {
    await _firestore.collection('orcamentos').add(orcamento.toMap());
  }

  static Stream<List<Orcamento>> getOrcamentosByDentista(String dentistaId) {
    return _firestore
        .collection('orcamentos')
        .where('dentista_id', isEqualTo: dentistaId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Orcamento.fromMap(doc.data(), doc.id)).toList());
  }

  static Future<void> updateOrcamento(Orcamento orcamento) async {
    await _firestore.collection('orcamentos').doc(orcamento.id).update(orcamento.toMap());
  }

  static Future<void> deleteOrcamento(String id) async {
    await _firestore.collection('orcamentos').doc(id).delete();
  }
}
