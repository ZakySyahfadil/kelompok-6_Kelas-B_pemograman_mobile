
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil data pengguna berdasarkan UID
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromFirestore(doc.data()!);
  }

  // Mengamati perubahan data pengguna secara real-time
  Stream<UserModel?> watchUser(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return UserModel.fromFirestore(doc.data()!);
    });
  }

  // Memperbarui data profil pengguna
  Future<void> updateUser({
    required String uid,
    required String name,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'name': name,
    });
  }

  // Memeriksa apakah pengguna merupakan admin
  Future<bool> isAdmin(String uid) async {
    final user = await getUser(uid);
    return user?.role == 'admin';
  }
}
