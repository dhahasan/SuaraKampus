import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';

class MockDataRepository {
  // Current user state
  AppUser currentUser = const AppUser(
    id: 'user_1',
    email: '2110511042@mahasiswa.kampus.ac.id',
    role: UserRole.student,
    verificationStatus: VerificationStatus.verified,
    monthlyQuotaUsed: 2,
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
      logs: [
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
      logs: [
        DispositionLog(time: '23 Okt, 14:00', text: 'Webhook terkirim ke IT helpdesk'),
      ],
    ),
  ];

  // List of Instagram posts for Admin Screen 19
  List<InstagramPost> instagramQueue = [
    const InstagramPost(
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
    const InstagramPost(
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
    const InstagramPost(
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

class CurrentUserNotifier extends StateNotifier<AppUser> {
  CurrentUserNotifier(super.initial);

  void setUser(AppUser user) => state = user;

  void toggleRole() {
    if (state.role == UserRole.student) {
      state = state.copyWith(role: UserRole.admin);
    } else {
      state = state.copyWith(role: UserRole.student);
    }
  }

  void setVerification(VerificationStatus status, {String? rejectionReason}) {
    state = state.copyWith(
      verificationStatus: status,
      rejectionReason: rejectionReason,
    );
  }

  void toggleQuota(bool isExhausted) {
    state = state.copyWith(
      monthlyQuotaUsed: isExhausted ? 5 : 2,
    );
  }

  void useQuota() {
    if (state.monthlyQuotaUsed < state.monthlyQuotaMax) {
      state = state.copyWith(monthlyQuotaUsed: state.monthlyQuotaUsed + 1);
    }
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, AppUser>((ref) {
  final repo = ref.watch(repositoryProvider);
  return CurrentUserNotifier(repo.currentUser);
});

class MenfessNotifier extends StateNotifier<List<Menfess>> {
  MenfessNotifier(super.initial);

  void addMenfess({
    required MenfessCategory category,
    required String body,
    String? attachmentName,
    bool allowInstagram = true,
    bool isAnonymous = true,
  }) {
    final newId = 'm_${DateTime.now().millisecondsSinceEpoch}';
    final code = 'MNF-${1045 + state.length + 1}';
    final item = Menfess(
      id: newId,
      code: code,
      category: category,
      body: body,
      attachmentName: attachmentName,
      status: MenfessStatus.pending,
      allowInstagram: allowInstagram,
      isAnonymous: isAnonymous,
      supportCount: 0,
      reportCount: 0,
      createdAt: DateTime.now(),
    );
    state = [item, ...state];
  }

  void toggleSupport(String id) {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(supportCount: m.supportCount + 1) else m
    ];
  }

  void reportMenfess(String id, String reason) {
    state = [
      for (final m in state)
        if (m.id == id)
          m.copyWith(
            reportCount: m.reportCount + 1,
            reportReasonSummary: reason,
          )
        else
          m
    ];
  }

  void approveMenfess(String id) {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(status: MenfessStatus.approved) else m
    ];
  }

  void rejectMenfess(String id) {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(status: MenfessStatus.rejected) else m
    ];
  }

  void censorText(String id) {
    state = [
      for (final m in state)
        if (m.id == id)
          m.copyWith(
            body: m.body.replaceAll(RegExp(r'Pak [A-Za-z]+|Bu [A-Za-z]+'), 'Dosen ***'),
            isSensitive: false,
          )
        else
          m
    ];
  }

  void deleteMenfess(String id) {
    state = state.where((m) => m.id != id).toList();
  }
}

final menfessProvider =
    StateNotifierProvider<MenfessNotifier, List<Menfess>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return MenfessNotifier(repo.menfessList);
});

class DispositionNotifier extends StateNotifier<List<Disposition>> {
  DispositionNotifier(super.initial);

  void markResolved(String id) {
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(status: 'Selesai', isOverdue: false) else d
    ];
  }

  void sendReminder(String id) {
    // adds log
    state = [
      for (final d in state)
        if (d.id == id)
          d.copyWith(logs: [
            ...d.logs,
            DispositionLog(
              time: 'Baru saja',
              text: 'Pengingat dikirimkan ke pihak pimpinan unit',
            ),
          ])
        else
          d
    ];
  }
}

final dispositionProvider =
    StateNotifierProvider<DispositionNotifier, List<Disposition>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return DispositionNotifier(repo.dispositions);
});

class InstagramNotifier extends StateNotifier<List<InstagramPost>> {
  InstagramNotifier(super.initial);

  void toggleAutoPublish(String id) {
    state = [
      for (final post in state)
        if (post.id == id)
          post.copyWith(autoPublish: !post.autoPublish)
        else
          post
    ];
  }

  void generateBatch() {
    // Simulates generating fresh queue items
  }
}

final instagramProvider =
    StateNotifierProvider<InstagramNotifier, List<InstagramPost>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return InstagramNotifier(repo.instagramQueue);
});
