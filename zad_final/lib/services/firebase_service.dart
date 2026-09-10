import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(name);
    await _db.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': email.trim(),
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'impactKg': 0,
      'points': 0,
    });
    return cred;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }
}

class DonationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getDonations() {
    return _db
        .collection('donations')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getMyDonations() {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('donations')
        .where('donorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> addDonation({
    required String title,
    required double weightKg,
    required String category,
    required String expiryLabel,
    required String collectionAddress,
    required bool isUrgent,
  }) async {
    final uid = AuthService.currentUser?.uid;
    await _db.collection('donations').add({
      'title': title,
      'weightKg': weightKg,
      'category': category,
      'expiryLabel': expiryLabel,
      'collectionAddress': collectionAddress,
      'isUrgent': isUrgent,
      'donorId': uid,
      'status': 'متاح',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteDonation(String donationId) async {
    await _db.collection('donations').doc(donationId).delete();
  }

  static Future<void> claimDonation(String donationId) async {
    final uid = AuthService.currentUser?.uid;
    await _db.collection('donations').doc(donationId).update({
      'status': 'محجوز',
      'claimedBy': uid,
      'claimedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getIncidents() {
    return _db
        .collection('incidents')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  static Future<void> logIncident({
    required String batchNumber,
    required String title,
    required String type,
    required String detail,
    required String origin,
    required String note,
  }) async {
    final uid = AuthService.currentUser?.uid;
    await _db.collection('incidents').add({
      'batchNumber': batchNumber,
      'title': title,
      'type': type,
      'detail': detail,
      'origin': origin,
      'note': note,
      'reportedBy': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteIncident(String incidentId) async {
    await _db.collection('incidents').doc(incidentId).delete();
  }
}
