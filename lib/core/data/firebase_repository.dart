import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/app_models.dart';
import '../services/firebase_service.dart';

class FirebaseRepository {
  final FirebaseService _service = FirebaseService();

  FirebaseAuth? get _auth => _service.auth;
  FirebaseFirestore? get _firestore => _service.firestore;
  FirebaseStorage? get _storage => _service.storage;

  bool get isReady => _service.isInitialized && _firestore != null;

  // =========================================================================
  // 1. AUTHENTICATION & USER MANAGEMENT
  // =========================================================================

  Future<AppUser?> signIn(String email, String password) async {
    if (!isReady || _auth == null) return null;

    try {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        await _auth!.signOut();
        return null;
      }

      // Ambil profil berdasarkan UID dari Firebase Authentication.
      final userProfile = await getUserProfile(
        firebaseUser.uid,
        email: firebaseUser.email ?? email.trim(),
      );

      // Jika profil tidak valid atau tidak ditemukan,
      // akhiri sesi login Firebase.
      if (userProfile == null) {
        await _auth!.signOut();
        debugPrint('Login dibatalkan karena profil Firestore tidak valid.');
        return null;
      }

      return userProfile;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth signIn error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Firebase signIn general error: $e');

      await _auth!.signOut();
      return null;
    }
  }

  Future<AppUser?> signUp(
    String email,
    String password, {
    UserRole role = UserRole.student,
  }) async {
    if (!isReady || _auth == null) return null;

    // Registrasi dari aplikasi hanya diperbolehkan untuk mahasiswa.
    if (role != UserRole.student) {
      debugPrint('Registrasi admin tidak diperbolehkan dari aplikasi.');
      return null;
    }

    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) return null;

      final newUser = AppUser(
        id: uid,
        email: email,
        role: UserRole.student,
        verificationStatus: VerificationStatus.pending,
        monthlyQuotaUsed: 0,
        monthlyQuotaMax: 5,
      );

      await _firestore!.collection('users').doc(uid).set(newUser.toJson());

      return newUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth signUp error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Firebase signUp error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
  }

  Future<AppUser?> getUserProfile(String uid, {String? email}) async {
    if (!isReady) return null;

    try {
      final doc = await _firestore!.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        debugPrint('Profil pengguna tidak ditemukan di Firestore.');
        return null;
      }

      final data = doc.data()!;

      // Pastikan ID dokumen dan UID pengguna cocok.
      if (data['id'] != uid) {
        debugPrint('UID dan ID profil tidak cocok.');
        return null;
      }

      // Pastikan email profil sesuai dengan akun Firebase Auth.
      if (email != null && data['email'] != email) {
        debugPrint('Email profil tidak cocok.');
        return null;
      }

      return AppUser.fromJson(data);
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return null;
    }
  }

  Future<void> updateVerificationStatus({
    required String uid,
    required VerificationStatus status,
    String? rejectionReason,
    String? ktmUrl,
  }) async {
    if (!isReady) return;

    try {
      final updateData = <String, dynamic>{'verificationStatus': status.name};
      if (rejectionReason != null)
        updateData['rejectionReason'] = rejectionReason;
      if (ktmUrl != null) updateData['ktmUrl'] = ktmUrl;

      await _firestore!.collection('users').doc(uid).update(updateData);
    } catch (e) {
      debugPrint('Update verification error: $e');
    }
  }

  Future<void> useUserQuota(String uid) async {
    if (!isReady) return;
    try {
      await _firestore!.collection('users').doc(uid).update({
        'monthlyQuotaUsed': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('Use user quota error: $e');
    }
  }

  // =========================================================================
  // 2. MENFESS (ASPIRASI)
  // =========================================================================

  // Stream realtime untuk update data otomatis saat ada data baru dari Firestore
  Stream<List<Menfess>> getMenfessStream({
    MenfessCategory? category,
    MenfessStatus? status,
  }) {
    if (!isReady) {
      return Stream.value([]);
    }

    Query<Map<String, dynamic>> query = _firestore!
        .collection('menfess')
        .orderBy('createdAt', descending: true);

    if (category != null && category != MenfessCategory.semua) {
      query = query.where('category', isEqualTo: category.name);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Menfess.fromJson(data);
      }).toList();
    });
  }

  Future<List<Menfess>> fetchMenfessList() async {
    if (!isReady) return [];

    try {
      final snapshot = await _firestore!
          .collection('menfess')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Menfess.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('fetchMenfessList Firestore error: $e');
      return [];
    }
  }

  Future<Menfess?> createMenfess({
    required String userId,
    required MenfessCategory category,
    required String body,
    String? attachmentName,
    String? attachmentUrl,
    bool allowInstagram = true,
    bool isAnonymous = true,
  }) async {
    if (!isReady) return null;

    try {
      // Hitung total data untuk nomor urut kode MNF-XXXX
      final countSnap = await _firestore!.collection('menfess').count().get();
      final total = countSnap.count ?? 0;
      final code = 'MNF-${1045 + total + 1}';

      // Deteksi otomatis nama dosen/orang (etika kampus)
      final hasNames = RegExp(
        r'\b(pak|bu|bapak|ibu|prof|dr)\s+[a-z]+',
        caseSensitive: false,
      ).hasMatch(body);

      final newDocRef = _firestore!.collection('menfess').doc();
      final menfess = Menfess(
        id: newDocRef.id,
        code: code,
        category: category,
        body: body,
        attachmentName: attachmentName,
        attachmentUrl: attachmentUrl,
        status: MenfessStatus.pending,
        allowInstagram: allowInstagram,
        isAnonymous: isAnonymous,
        supportCount: 0,
        reportCount: 0,
        isSensitive: hasNames,
        reportReasonSummary: hasNames
            ? 'Terdeteksi menyebut nama/inisial pihak civitas secara langsung.'
            : null,
        createdAt: DateTime.now(),
      );

      await newDocRef.set(menfess.toJson());

      // Update kuota user
      await useUserQuota(userId);

      return menfess;
    } catch (e) {
      debugPrint('createMenfess Firestore error: $e');
      return null;
    }
  }

  Future<void> toggleSupport(String menfessId) async {
    if (!isReady) return;
    try {
      await _firestore!.collection('menfess').doc(menfessId).update({
        'supportCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('toggleSupport Firestore error: $e');
    }
  }

  Future<void> reportMenfess(String menfessId, String reason) async {
    if (!isReady) return;
    try {
      // Simpan riwayat laporan ke subcollection/collection reports
      await _firestore!.collection('reports').add({
        'menfessId': menfessId,
        'reason': reason,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Update jumlah laporan di dokumen menfess
      final menfessRef = _firestore!.collection('menfess').doc(menfessId);
      final doc = await menfessRef.get();
      final currentReports = (doc.data()?['reportCount'] as num?)?.toInt() ?? 0;
      final newReportCount = currentReports + 1;

      await menfessRef.update({
        'reportCount': newReportCount,
        'reportReasonSummary': reason,
        if (newReportCount >= 3) 'isSensitive': true,
      });
    } catch (e) {
      debugPrint('reportMenfess Firestore error: $e');
    }
  }

  Future<void> moderateMenfess(String menfessId, String action) async {
    if (!isReady) return;

    try {
      final docRef = _firestore!.collection('menfess').doc(menfessId);

      switch (action) {
        case 'approve':
          await docRef.update({'status': MenfessStatus.approved.name});
          break;
        case 'reject':
          await docRef.update({'status': MenfessStatus.rejected.name});
          break;
        case 'censor':
          final snap = await docRef.get();
          final body = snap.data()?['body'] as String? ?? '';
          final censored = body.replaceAll(
            RegExp(r'\b(Pak|Bu|Bapak|Ibu)\s+[A-Za-z*]+', caseSensitive: false),
            'Dosen ***',
          );
          await docRef.update({'body': censored, 'isSensitive': false});
          break;
        case 'delete':
          await docRef.delete();
          break;
      }
    } catch (e) {
      debugPrint('moderateMenfess Firestore error: $e');
    }
  }

  // =========================================================================
  // 3. DISPOSITIONS (TINDAK LANJUT ADMIN)
  // =========================================================================

  Stream<List<Disposition>> getDispositionsStream() {
    if (!isReady) return Stream.value([]);

    return _firestore!.collection('dispositions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Disposition.fromJson(data);
      }).toList();
    });
  }

  Future<void> resolveDisposition(String dispositionId) async {
    if (!isReady) return;
    try {
      await _firestore!.collection('dispositions').doc(dispositionId).update({
        'status': 'Selesai',
        'isOverdue': false,
      });
    } catch (e) {
      debugPrint('resolveDisposition error: $e');
    }
  }

  Future<void> sendDispositionReminder(String dispositionId) async {
    if (!isReady) return;
    try {
      final newLog = {
        'time': 'Baru saja',
        'text': 'Pengingat otomatis dikirimkan ke pihak pimpinan unit',
      };
      await _firestore!.collection('dispositions').doc(dispositionId).update({
        'logs': FieldValue.arrayUnion([newLog]),
      });
    } catch (e) {
      debugPrint('sendDispositionReminder error: $e');
    }
  }

  // =========================================================================
  // 4. INSTAGRAM QUEUE (SOSIAL MEDIA OTOMASI)
  // =========================================================================

  Stream<List<InstagramPost>> getInstagramQueueStream() {
    if (!isReady) return Stream.value([]);

    return _firestore!.collection('instagram_queue').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return InstagramPost.fromJson(data);
      }).toList();
    });
  }

  // Toggle Auto Publish Instagram
  Future<void> toggleInstagramAutoPublish(String id, bool currentValue) async {
    if (!isReady) return;

    try {
      await _firestore!.collection('instagram_queue').doc(id).update({
        'autoPublish': !currentValue,
      });
    } catch (e) {
      debugPrint('toggleInstagramAutoPublish error: $e');
    }
  }

  // Update caption Instagram
  Future<void> updateInstagramCaption(String id, String caption) async {
    if (!isReady) return;

    try {
      await _firestore!.collection('instagram_queue').doc(id).update({
        'caption': caption,
      });
    } catch (e) {
      debugPrint('updateInstagramCaption error: $e');
    }
  }

  // Hapus postingan Instagram
  Future<void> deleteInstagramPost(String id) async {
    if (!isReady) return;

    try {
      await _firestore!.collection('instagram_queue').doc(id).delete();
    } catch (e) {
      debugPrint('deleteInstagramPost error: $e');
    }
  }

  // Generate Instagram Batch berdasarkan menfess yang disetujui
  Future<void> generateInstagramBatch(List<Menfess> menfessList) async {
    if (!isReady) return;

    try {
      // Ambil antrean Instagram yang sudah ada
      final queueSnapshot = await _firestore!
          .collection('instagram_queue')
          .get();

      final existingMenfessIds = queueSnapshot.docs
          .map((doc) => doc.data()['menfessId'] as String?)
          .whereType<String>()
          .toSet();

      // Ambil menfess yang disetujui dan mengizinkan publikasi Instagram
      final eligibleMenfess = menfessList.where((menfess) {
        return menfess.status == MenfessStatus.approved &&
            menfess.allowInstagram &&
            !existingMenfessIds.contains(menfess.id);
      }).toList();

      if (eligibleMenfess.isEmpty) {
        debugPrint('Tidak ada menfess yang bisa dibuat menjadi postingan.');
        return;
      }

      final batch = _firestore!.batch();
      final total = queueSnapshot.docs.length;
      final now = DateTime.now();

      for (var i = 0; i < eligibleMenfess.length; i++) {
        final menfess = eligibleMenfess[i];

        final postId = 'ig_${now.millisecondsSinceEpoch}_$i';

        final newPost = InstagramPost(
          id: postId,
          scheduleNumber: '#${86 + total + i}',
          menfessId: menfess.id,
          scheduledTimeText: 'Hari ini, 21:00 WIB',
          format: 'Format Single Post',
          quoteText: menfess.body,
          caption: '${menfess.body}\n\n#SuaraKampus',
          facultyTag: menfess.category.name,
          autoPublish: true,
          status: 'Draft Desain Feed',
        );

        final docRef = _firestore!.collection('instagram_queue').doc(postId);

        batch.set(docRef, newPost.toJson());
      }

      await batch.commit();

      debugPrint('${eligibleMenfess.length} postingan berhasil dibuat.');
    } catch (e) {
      debugPrint('generateInstagramBatch error: $e');
    }
  }

  // =========================================================================
  // 5. FIREBASE STORAGE (UPLOAD KTM & BUKTI FOTO)
  // =========================================================================

  Future<String?> uploadImageFile(String localPath, String folder) async {
    if (!isReady || _storage == null) return null;

    try {
      final file = File(localPath);
      if (!await file.exists()) return null;

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final storageRef = _storage!.ref().child('$folder/$fileName');

      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('uploadImageFile FirebaseStorage error: $e');
      return null;
    }
  }

  // =========================================================================
  // 6. SEED DATA AWAL (JIKA FIRESTORE KOSONG)
  // =========================================================================

  Future<void> seedInitialDataIfEmpty({
    required List<Menfess> initialMenfess,
    required List<Disposition> initialDispositions,
    required List<InstagramPost> initialInstagram,
  }) async {
    if (!isReady) return;

    try {
      final menfessCheck = await _firestore!
          .collection('menfess')
          .limit(1)
          .get();
      if (menfessCheck.docs.isEmpty) {
        debugPrint('🌱 Memasukkan seed data awal ke Firestore...');
        final batch = _firestore!.batch();

        for (final m in initialMenfess) {
          final doc = _firestore!.collection('menfess').doc(m.id);
          batch.set(doc, m.toJson());
        }

        for (final d in initialDispositions) {
          final doc = _firestore!.collection('dispositions').doc(d.id);
          batch.set(doc, d.toJson());
        }

        for (final ig in initialInstagram) {
          final doc = _firestore!.collection('instagram_queue').doc(ig.id);
          batch.set(doc, ig.toJson());
        }

        await batch.commit();
        debugPrint(' Seed data awal berhasil dimasukkan ke Firestore!');
      }
    } catch (e) {
      debugPrint('seedInitialDataIfEmpty error: $e');
    }
  }
}
