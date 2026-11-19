import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';
import 'database_repository.dart';
import 'firebase_repository.dart';

class MockDataRepository {
  // Current user state
  AppUser currentUser = const AppUser(
  id: 'guest',
  email: '',
  role: UserRole.student,
  verificationStatus: VerificationStatus.pending,
  monthlyQuotaUsed: 0,
  monthlyQuotaMax: 5,
);

  // List of Menfess items
  List<Menfess> menfessList = [
    Menfess(
      id: 'm1',
      code: 'MNF-1042',
      category: MenfessCategory.sarpras,
      body:
          'Kursi di ruang kuliah B203 banyak yang patah dan paku mencuat berbahaya. Tolong pihak sarpras segera cek sebelum ada yang terluka saat perkuliahan berlangsung.',
      attachmentUrl: 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=600',
      attachmentName: 'Lampiran_B203_Kerusakan.jpg (1.2 MB)',
      status: MenfessStatus.pending,
      allowInstagram: true,
      isAnonymous: true,
      supportCount: 38,
      reportCount: 0,
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    Menfess(
      id: 'm2',
      code: 'MNF-1038',
      category: MenfessCategory.akademik,
      body:
          'Dosen mata kuliah Algoritma Pak B** tidak pernah masuk tapi tiba-tiba ngasih tugas deadline 2 jam di tengah malam. Sangat tidak masuk akal untuk kelas reguler.',
      status: MenfessStatus.pending,
      allowInstagram: false,
      isAnonymous: true,
      supportCount: 28,
      reportCount: 3,
      reportReasonSummary:
          'Menyebut inisial dosen secara spesifik yang berpotensi melanggar pedoman etika digital kampus.',
      isSensitive: true,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    Menfess(
      id: 'm3',
      code: 'MNF-1045',
      category: MenfessCategory.sarpras,
      body:
          'Kantin Fakultas Teknik tolong disediakan tempat sampah terpisah untuk organik dan anorganik. Saat ini sering meluber pas jam makan siang.',
      status: MenfessStatus.pending,
      allowInstagram: true,
      isAnonymous: true,
      supportCount: 15,
      reportCount: 0,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Menfess(
      id: 'm4',
      code: 'MNF-1020',
      category: MenfessCategory.layananIt,
      body: 'Wi-Fi di gedung C sering putus saat jam kuliah siang.',
      status: MenfessStatus.inProgress,
      allowInstagram: true,
      isAnonymous: true,
      supportCount: 42,
      reportCount: 0,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Menfess(
      id: 'm5',
      code: 'MNF-1015',
      category: MenfessCategory.sarpras,
      body: 'AC di ruang lab 3 tidak dingin sejak minggu lalu.',
      status: MenfessStatus.pending,
      allowInstagram: true,
      isAnonymous: true,
      supportCount: 17,
      reportCount: 0,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Menfess(
      id: 'm6',
      code: 'MNF-1011',
      category: MenfessCategory.keuangan,
      body: 'Alur pembayaran UKT sulit dipahami, mohon dibuatkan panduan singkat.',
      status: MenfessStatus.resolved,
      allowInstagram: true,
      isAnonymous: true,
      supportCount: 68,
      reportCount: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // List of Dispositions for Admin Screen 18
  List<Disposition> dispositions = [
    Disposition(
      id: 'd1',
      ticketCode: '#SK-8821',
      menfessId: 'm1',
      unit: 'Biro Sarana & Prasarana',
      unitLocation: 'Gedung 3',
      status: 'Diproses',
      estimateRemaining: 'Estimasi respons tersisa: 2 hari kerja',
      isOverdue: false,
      menfessQuote:
          'AC lab komputer gedung 3 bocor dan air merembes ke kabel stopkontak.',
      correspondenceDetail:
          'Terkirim ke email kabag_sarpras@kampus.ac.id pada 24 Okt. Menunggu konfirmasi pengerjaan fisik di lapangan.',
      logs: const [
        DispositionLog(time: '24 Okt, 09:15', text: 'Tiket diterbitkan oleh Admin'),
        DispositionLog(time: '24 Okt, 10:00', text: 'Email terkirim ke Biro Sarpras'),
      ],
    ),
    Disposition(
      id: 'd2',
      ticketCode: '#SK-8819',
      menfessId: 'm4',
      unit: 'Layanan IT & Jaringan',
      unitLocation: 'Perpustakaan Lt. 2',
      status: 'Menunggu Respon',
      estimateRemaining: 'Telah melebihi 24 jam belum dibaca',
      isOverdue: true,
      menfessQuote:
          'Koneksi Wi-Fi Eduroam di perpustakaan lantai 2 tidak bisa autentikasi sejak Senin.',
      correspondenceDetail:
          'Tiket terdistribusi otomatis via webhook kampus. Unit IT belum menetapkan PIC penanganan jaringan.',
      logs: const [
        DispositionLog(time: '23 Okt, 14:00', text: 'Webhook terkirim ke IT helpdesk'),
      ],
    ),
  ];

  // List of Instagram posts for Admin Screen 19
  List<InstagramPost> instagramQueue = const [
    InstagramPost(
      id: 'ig1',
      scheduleNumber: '#83',
      menfessId: 'm6',
      scheduledTimeText: 'Hari ini, 19:00 WIB',
      format: 'Carousel (3/3)',
      quoteText:
          'Alur pembayaran UKT via teller bank mitra sangat membingungkan, tolong..',
      caption:
          'Sobat Kampus, ada masukan penting seputar alur teller UKT semester ini. Mari simak pembahasannya...\n\n#SuaraKampus #AspirasiMahasiswa #UKTKampus #Advokasi',
      facultyTag: 'Fakultas Ekonomi',
      autoPublish: true,
      status: 'Terjadwal',
    ),
    InstagramPost(
      id: 'ig2',
      scheduleNumber: '#84',
      menfessId: 'm4',
      scheduledTimeText: 'Besok, 12:00 WIB',
      format: 'Format Single Post',
      quoteText:
          'Wi-Fi gedung C sering putus saat praktikum daring lab lantai 3. Mohon dicek.',
      caption:
          'Pengaduan Sarana Prasarana: Masalah jaringan Wi-Fi di Gedung C sedang dalam penanganan unit terkait.',
      facultyTag: 'Sarana Prasarana',
      autoPublish: true,
      status: 'Terjadwal',
    ),
    InstagramPost(
      id: 'ig3',
      scheduleNumber: '#85',
      menfessId: 'm7',
      scheduledTimeText: '20:30 BESOK',
      format: 'Format Single Post + Siap Antre',
      quoteText: 'Jadwal Bus Kampus Malam sering tidak tepat waktu.',
      caption: 'Evaluasi transportasi internal kampus untuk rute malam.',
      facultyTag: 'Transportasi',
      autoPublish: false,
      status: 'Draft Desain Feed',
    ),
  ];

  // Analytics summary for Admin Screen 20
  AnalyticsSummary analytics = const AnalyticsSummary(
    total: 284,
    totalTrend: '+18% bln lalu',
    resolvedRate: 89.2,
    resolvedRateNote: 'Tindak lanjut efektif',
    avgResponseDays: 1.4,
    avgResponseNote: 'Kecepatan unit baik',
    violations: 12,
    violationsNote: 'Semua tertangani',
    weeklyTrend: [
      WeeklyTrend(week: 'Mgg 1', incoming: 65, resolved: 58),
      WeeklyTrend(week: 'Mgg 2', incoming: 72, resolved: 66),
      WeeklyTrend(week: 'Mgg 3', incoming: 80, resolved: 71),
      WeeklyTrend(week: 'Mgg 4', incoming: 67, resolved: 60),
    ],
    categoryDistribution: [
      CategoryDistribution(categoryName: 'Sarpras & Prasarana', count: 132, percentage: 0.46),
      CategoryDistribution(categoryName: 'Akademik & Dosen', count: 78, percentage: 0.28),
      CategoryDistribution(categoryName: 'Keuangan & UKT', count: 45, percentage: 0.16),
      CategoryDistribution(categoryName: 'Layanan IT & Fasilitas', count: 29, percentage: 0.10),
    ],
    unitPerformance: [
      UnitPerformance(
        name: 'Biro Sarpras',
        avgResponse: 'Rata-rata 1.1 hari respon',
        rate: 94.0,
        badgeText: 'Kecepatan Baik',
        badgeType: 'success',
      ),
      UnitPerformance(
        name: 'Biro Akademik',
        avgResponse: 'Rata-rata 1.8 hari respon',
        rate: 82.0,
        badgeText: 'Normal',
        badgeType: 'info',
      ),
      UnitPerformance(
        name: 'Bagian Keuangan',
        avgResponse: 'Rata-rata 3.2 hari respon',
        rate: 71.0,
        badgeText: 'Perlu Eskalasi',
        badgeType: 'danger',
      ),
    ],
  );
}

// -------------------------------------------------------------
// RIVERPOD NOTIFIERS & PROVIDERS
// -------------------------------------------------------------

final repositoryProvider = Provider<MockDataRepository>((ref) {
  return MockDataRepository();
});

final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
  return FirebaseRepository();
});

final firebaseReadyProvider = Provider<bool>((ref) {
  return ref.watch(firebaseRepositoryProvider).isReady;
});

// Tetap sediakan databaseRepositoryProvider untuk kompatibilitas
final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository();
});

// Provider status koneksi database
final databaseConnectionProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final firebaseRepo = ref.watch(firebaseRepositoryProvider);
  if (firebaseRepo.isReady) {
    return {
      'status': 'FIREBASE_CONNECTED',
      'database': 'Firebase Cloud Firestore',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  return {
    'status': 'LOCAL_FALLBACK',
    'database': 'Mock & Local In-Memory DB',
    'timestamp': DateTime.now().toIso8601String(),
  };
});

class CurrentUserNotifier extends StateNotifier<AppUser> {
  final FirebaseRepository _firebaseRepo;

  CurrentUserNotifier(super.initial, this._firebaseRepo);

  // Memperbarui user yang sedang aktif di state aplikasi.
  void setUser(AppUser user) {
    state = user;
  }

  Future<bool> login(String email, String password) async {
  if (!_firebaseRepo.isReady) {
    debugPrint('Firebase belum siap. Login dibatalkan.');
    return false;
  }

  try {
    final user = await _firebaseRepo.signIn(email, password);

    if (user == null) {
      debugPrint('Login gagal: profil pengguna tidak valid.');
      return false;
    }

    state = user;
    return true;
  } catch (e) {
    debugPrint('Firebase login error: $e');
    return false;
  }
}

  Future<bool> register(
  String email,
  String password, {
  UserRole role = UserRole.student,
}) async {
  if (!_firebaseRepo.isReady) {
    debugPrint('Firebase belum siap. Registrasi dibatalkan.');
    return false;
  }

  if (role != UserRole.student) {
    debugPrint('Registrasi hanya diperbolehkan untuk mahasiswa.');
    return false;
  }

  try {
    final user = await _firebaseRepo.signUp(
      email,
      password,
      role: UserRole.student,
    );

    if (user == null) {
      debugPrint('Registrasi gagal.');
      return false;
    }

    state = user;
    return true;
  } catch (e) {
    debugPrint('Firebase register error: $e');
    return false;
  }
}

  Future<void> setVerification(VerificationStatus status,
      {String? rejectionReason, String? ktmUrl}) async {
    state = state.copyWith(
      verificationStatus: status,
      rejectionReason: rejectionReason,
      ktmUrl: ktmUrl,
    );
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.updateVerificationStatus(
        uid: state.id,
        status: status,
        rejectionReason: rejectionReason,
        ktmUrl: ktmUrl,
      );
    }
  }

  void toggleQuota(bool isExhausted) {
    state = state.copyWith(
      monthlyQuotaUsed: isExhausted ? 5 : 2,
    );
  }

  void useQuota() {
    if (state.monthlyQuotaUsed < state.monthlyQuotaMax) {
      state = state.copyWith(monthlyQuotaUsed: state.monthlyQuotaUsed + 1);
      if (_firebaseRepo.isReady) {
        _firebaseRepo.useUserQuota(state.id);
      }
    }
  }

  Future<void> logout() async {
  try {
    await _firebaseRepo.signOut();
  } catch (e) {
    debugPrint('Firebase logout error: $e');
  } finally {
    state = const AppUser(
      id: 'guest',
      email: '',
      role: UserRole.student,
      verificationStatus: VerificationStatus.pending,
      monthlyQuotaUsed: 0,
      monthlyQuotaMax: 5,
    );
  }
}
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, AppUser>((ref) {
  final repo = ref.watch(repositoryProvider);
  final firebaseRepo = ref.watch(firebaseRepositoryProvider);
  return CurrentUserNotifier(repo.currentUser, firebaseRepo);
});

class MenfessNotifier extends StateNotifier<List<Menfess>> {
  final FirebaseRepository _firebaseRepo;
  StreamSubscription<List<Menfess>>? _subscription;

  MenfessNotifier(super.initial, this._firebaseRepo) {
    _initDataAndStream();
  }

  void _initDataAndStream() {
  if (_firebaseRepo.isReady) {
    _subscription = _firebaseRepo.getMenfessStream().listen((firebaseList) {
      state = firebaseList;
    });
  }
}

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> fetchFromDatabase({
  MenfessCategory? category,
  MenfessStatus? status,
}) async {
  if (_firebaseRepo.isReady) {
    final list = await _firebaseRepo.fetchMenfessList();
    state = list;
  }
}

  Future<void> addMenfess({
    required MenfessCategory category,
    required String body,
    String? attachmentName,
    String? attachmentUrl,
    bool allowInstagram = true,
    bool isAnonymous = true,
    String userId = 'user_1',
  }) async {
    final newId = 'm_${DateTime.now().millisecondsSinceEpoch}';
    final code = 'MNF-${1045 + state.length + 1}';
    final hasNames = RegExp(
      r'\b(pak|bu|bapak|ibu|prof|dr)\s+[a-z]+',
      caseSensitive: false,
    ).hasMatch(body);

    final item = Menfess(
      id: newId,
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
    state = [item, ...state];

    if (_firebaseRepo.isReady) {
      await _firebaseRepo.createMenfess(
        userId: userId,
        category: category,
        body: body,
        attachmentName: attachmentName,
        attachmentUrl: attachmentUrl,
        allowInstagram: allowInstagram,
        isAnonymous: isAnonymous,
      );
    }
  }

  Future<void> toggleSupport(String id, {String? userId}) async {
    state = [
      for (final m in state)
        if (m.id == id)
          m.copyWith(
            supportCount: m.isSupportedByMe
                ? (m.supportCount - 1).clamp(0, 999999)
                : m.supportCount + 1,
            isSupportedByMe: !m.isSupportedByMe,
          )
        else
          m
    ];
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.toggleSupport(id);
    }
  }

  Future<void> reportMenfess(String id, String reason) async {
    state = [
      for (final m in state)
        if (m.id == id)
          m.copyWith(
            reportCount: m.reportCount + 1,
            reportReasonSummary: reason,
            isSensitive: (m.reportCount + 1) >= 3 ? true : m.isSensitive,
          )
        else
          m
    ];
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.reportMenfess(id, reason);
    }
  }

  Future<void> approveMenfess(String id) async {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(status: MenfessStatus.approved) else m
    ];
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.moderateMenfess(id, 'approve');
    }
  }

  Future<void> rejectMenfess(String id) async {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(status: MenfessStatus.rejected) else m
    ];
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.moderateMenfess(id, 'reject');
    }
  }

  Future<void> censorText(String id) async {
    state = [
      for (final m in state)
        if (m.id == id)
          m.copyWith(
            body: m.body.replaceAll(
              RegExp(
                r'\b(Pak|Bu|Bapak|Ibu)\s+[A-Za-z*]+',
                caseSensitive: false,
              ),
              'Dosen ***',
            ),
            isSensitive: false,
          )
        else
          m
    ];

    if (_firebaseRepo.isReady) {
      await _firebaseRepo.moderateMenfess(id, 'censor');
    }
  }

  Future<void> approveAllPending() async {
  final pendingItems = state
      .where((m) => m.status == MenfessStatus.pending)
      .toList();

  state = [
    for (final m in state)
      if (m.status == MenfessStatus.pending)
        m.copyWith(status: MenfessStatus.approved)
      else
        m,
  ];

  if (_firebaseRepo.isReady) {
    for (final m in pendingItems) {
      await _firebaseRepo.moderateMenfess(m.id, 'approve');
    }
  }
}

  Future<void> deleteMenfess(String id) async {
    state = state.where((m) => m.id != id).toList();
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.moderateMenfess(id, 'delete');
    }
  }
}

final menfessProvider =
    StateNotifierProvider<MenfessNotifier, List<Menfess>>((ref) {
  final repo = ref.watch(repositoryProvider);
  final firebaseRepo = ref.watch(firebaseRepositoryProvider);
  return MenfessNotifier(repo.menfessList, firebaseRepo);
});

class DispositionNotifier extends StateNotifier<List<Disposition>> {
  final FirebaseRepository _firebaseRepo;
  StreamSubscription<List<Disposition>>? _subscription;

  DispositionNotifier(super.initial, this._firebaseRepo) {
  if (_firebaseRepo.isReady) {
    _subscription = _firebaseRepo.getDispositionsStream().listen((list) {
      state = list;
    });
  }
}

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> markResolved(String id) async {
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(status: 'Selesai', isOverdue: false) else d
    ];
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.resolveDisposition(id);
    }
  }

  Future<void> sendReminder(String id) async {
    state = [
      for (final d in state)
        if (d.id == id)
          d.copyWith(logs: [
            ...d.logs,
            const DispositionLog(
              time: 'Baru saja',
              text: 'Pengingat dikirimkan ke pihak pimpinan unit',
            ),
          ])
        else
          d
    ];
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.sendDispositionReminder(id);
    }
  }
}

final dispositionProvider =
    StateNotifierProvider<DispositionNotifier, List<Disposition>>((ref) {
  final repo = ref.watch(repositoryProvider);
  final firebaseRepo = ref.watch(firebaseRepositoryProvider);
  return DispositionNotifier(repo.dispositions, firebaseRepo);
});


class InstagramNotifier extends StateNotifier<List<InstagramPost>> {
  final FirebaseRepository _firebaseRepo;
  StreamSubscription<List<InstagramPost>>? _subscription;

  InstagramNotifier(super.initial, this._firebaseRepo) {
    if (_firebaseRepo.isReady) {
      _subscription =
          _firebaseRepo.getInstagramQueueStream().listen((list) {
        state = list;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Toggle Auto Publish
  Future<void> toggleAutoPublish(String id) async {
    final index = state.indexWhere((post) => post.id == id);

    if (index == -1) return;

    final current = state[index];

    state = [
      for (final post in state)
        if (post.id == id)
          post.copyWith(autoPublish: !post.autoPublish)
        else
          post,
    ];

    if (_firebaseRepo.isReady) {
      await _firebaseRepo.toggleInstagramAutoPublish(
        id,
        current.autoPublish,
      );
    }
  }

  // Generate Instagram Batch
  Future<void> generateBatch(List<Menfess> allMenfess) async {
    if (_firebaseRepo.isReady) {
      await _firebaseRepo.generateInstagramBatch(allMenfess);
    }
  }

  // Update Caption
  Future<void> updateCaption(String id, String caption) async {
    state = [
      for (final post in state)
        if (post.id == id)
          post.copyWith(caption: caption)
        else
          post,
    ];

    if (_firebaseRepo.isReady) {
      await _firebaseRepo.updateInstagramCaption(id, caption);
    }
  }

  // Delete Instagram Post
  Future<void> deletePost(String id) async {
    state = state.where((post) => post.id != id).toList();

    if (_firebaseRepo.isReady) {
      await _firebaseRepo.deleteInstagramPost(id);
    }
  }
}


final instagramProvider =
    StateNotifierProvider<InstagramNotifier, List<InstagramPost>>((ref) {
  final repo = ref.watch(repositoryProvider);
  final firebaseRepo = ref.watch(firebaseRepositoryProvider);
  return InstagramNotifier(repo.instagramQueue, firebaseRepo);
});
