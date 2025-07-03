import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_data.dart';

class UserFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return uid;
  }

  Future<void> saveUser(UserData userData) async {
    await _firestore.collection('users').doc(_uid).set(userData.toMap());
  }

  Future<UserData> fetchUser() async {
    final doc = await _firestore.collection('users').doc(_uid).get();

    if (!doc.exists) {
      throw Exception('User data not found');
    }

    return UserData.fromMap(doc.data()!);
  }
}
