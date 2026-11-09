import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/app_models.dart';
import 'database_constants.dart';
import 'db_helper.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  Database? _db;
  bool _isWebFallback = false;

  // In-memory fallback caches for web if sqlite wasm is unavailable
  final Map<String, AppUser> _webUsers = {};
  final List<Menfess> _webMenfess = [];
  final List<Disposition> _webDispositions = [];
  final List<InstagramPost> _webInstagramPosts = [];
  final Set<String> _supportedMenfessIds = {};

  Future<Database?> get database async {
    if (kIsWeb || _isWebFallback) return null;
    if (_db != null) return _db;
    try {
      _db = await _initDatabase();
      return _db;
    } catch (e) {
      debugPrint('AppDatabase initialization fallback activated: $e');
      _isWebFallback = true;
      _initWebFallback();
      return null;
    }
  }

  Future<void> init() async {
    if (kIsWeb) {
      _isWebFallback = true;
      _initWebFallback();
      return;
    }
    await database;
  }

  void _initWebFallback() {
    if (_webUsers.isNotEmpty) return;
    final now = DateTime.now();

    _webUsers['user_1'] = const AppUser(
      id: 'user_1',
      email: '2110511042@mahasiswa.kampus.ac.id',
      role: UserRole.student,
      verificationStatus: VerificationStatus.verified,
      monthlyQuotaUsed: 2,
      monthlyQuotaMax: 5,
    );

    _webUsers['admin_1'] = const AppUser(
      id: 'admin_1',
      email: 'admin@kampus.ac.id',
      role: UserRole.admin,
      verificationStatus: VerificationStatus.verified,
      monthlyQuotaUsed: 0,
      monthlyQuotaMax: 5,
    );

    _webMenfess.addAll([
      Menfess(
        id: 'm1',
        code: 'MNF-1042',
        category: MenfessCategory.sarpras,
        body:
            'Kursi di ruang kuliah B203 banyak yang patah dan paku mencuat berbahaya. Tolong pihak sarpras segera cek sebelum ada yang terluka saat perkuliahan berlangsung.',
        attachmentUrl:
            'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=600',
        attachmentName: 'Lampiran_B203_Kerusakan.jpg (1.2 MB)',
        status: MenfessStatus.pending,
        allowInstagram: true,
        isAnonymous: true,
        supportCount: 38,
        reportCount: 0,
        createdAt: now.subtract(const Duration(minutes: 12)),
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
        createdAt: now.subtract(const Duration(minutes: 45)),
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
        createdAt: now.subtract(const Duration(hours: 1)),
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
        createdAt: now.subtract(const Duration(hours: 3)),
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
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      Menfess(
        id: 'm6',
        code: 'MNF-1011',
        category: MenfessCategory.keuangan,
        body:
            'Alur pembayaran UKT sulit dipahami, mohon dibuatkan panduan singkat.',
        status: MenfessStatus.resolved,
        allowInstagram: true,
        isAnonymous: true,
        supportCount: 68,
        reportCount: 0,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ]);

    _webDispositions.addAll([
      const Disposition(
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
      const Disposition(
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
    ]);

    _webInstagramPosts.addAll([
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
    ]);
  }

  Future<Database> _initDatabase() async {
    await DbHelper.initPlatform();
    final dbPath = await DbHelper.getDatabasePath(DatabaseConstants.databaseName);

    return await openDatabase(
      dbPath,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableUsers} (
        ${DatabaseConstants.colUserId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colUserEmail} TEXT NOT NULL,
        ${DatabaseConstants.colUserRole} TEXT NOT NULL,
        ${DatabaseConstants.colUserVerificationStatus} TEXT NOT NULL,
        ${DatabaseConstants.colUserKtmUrl} TEXT,
        ${DatabaseConstants.colUserMonthlyQuotaUsed} INTEGER NOT NULL DEFAULT 0,
        ${DatabaseConstants.colUserMonthlyQuotaMax} INTEGER NOT NULL DEFAULT 5,
        ${DatabaseConstants.colUserRejectionReason} TEXT
      )
    ''');

    // 2. Menfess Table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableMenfess} (
        ${DatabaseConstants.colMenfessId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colMenfessCode} TEXT NOT NULL,
        ${DatabaseConstants.colMenfessCategory} TEXT NOT NULL,
        ${DatabaseConstants.colMenfessBody} TEXT NOT NULL,
        ${DatabaseConstants.colMenfessAttachmentUrl} TEXT,
        ${DatabaseConstants.colMenfessAttachmentName} TEXT,
        ${DatabaseConstants.colMenfessStatus} TEXT NOT NULL,
        ${DatabaseConstants.colMenfessAllowInstagram} INTEGER NOT NULL DEFAULT 1,
        ${DatabaseConstants.colMenfessIsAnonymous} INTEGER NOT NULL DEFAULT 1,
        ${DatabaseConstants.colMenfessSupportCount} INTEGER NOT NULL DEFAULT 0,
        ${DatabaseConstants.colMenfessReportCount} INTEGER NOT NULL DEFAULT 0,
        ${DatabaseConstants.colMenfessCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colMenfessReportReasonSummary} TEXT,
        ${DatabaseConstants.colMenfessIsSensitive} INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 3. Reports Table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableReports} (
        ${DatabaseConstants.colReportId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colReportMenfessId} TEXT NOT NULL,
        ${DatabaseConstants.colReportReason} TEXT NOT NULL,
        ${DatabaseConstants.colReportCreatedAt} TEXT NOT NULL
      )
    ''');

    // 4. Dispositions Table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableDispositions} (
        ${DatabaseConstants.colDispId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colDispTicketCode} TEXT NOT NULL,
        ${DatabaseConstants.colDispMenfessId} TEXT NOT NULL,
        ${DatabaseConstants.colDispUnit} TEXT NOT NULL,
        ${DatabaseConstants.colDispUnitLocation} TEXT NOT NULL,
        ${DatabaseConstants.colDispStatus} TEXT NOT NULL,
        ${DatabaseConstants.colDispEstimateRemaining} TEXT NOT NULL,
        ${DatabaseConstants.colDispIsOverdue} INTEGER NOT NULL DEFAULT 0,
        ${DatabaseConstants.colDispMenfessQuote} TEXT NOT NULL,
        ${DatabaseConstants.colDispCorrespondenceDetail} TEXT
      )
    ''');

    // 5. Disposition Logs Table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableDispositionLogs} (
        ${DatabaseConstants.colLogId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colLogDispositionId} TEXT NOT NULL,
        ${DatabaseConstants.colLogTime} TEXT NOT NULL,
        ${DatabaseConstants.colLogText} TEXT NOT NULL
      )
    ''');

    // 6. Instagram Posts Table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableInstagramPosts} (
        ${DatabaseConstants.colIgId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colIgScheduleNumber} TEXT NOT NULL,
        ${DatabaseConstants.colIgMenfessId} TEXT NOT NULL,
        ${DatabaseConstants.colIgScheduledTimeText} TEXT NOT NULL,
        ${DatabaseConstants.colIgFormat} TEXT NOT NULL,
        ${DatabaseConstants.colIgQuoteText} TEXT NOT NULL,
        ${DatabaseConstants.colIgCaption} TEXT NOT NULL,
        ${DatabaseConstants.colIgFacultyTag} TEXT NOT NULL,
        ${DatabaseConstants.colIgAutoPublish} INTEGER NOT NULL DEFAULT 1,
        ${DatabaseConstants.colIgStatus} TEXT NOT NULL
      )
    ''');

    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    await db.insert(DatabaseConstants.tableUsers, {
      DatabaseConstants.colUserId: 'user_1',
      DatabaseConstants.colUserEmail: '2110511042@mahasiswa.kampus.ac.id',
      DatabaseConstants.colUserRole: UserRole.student.name,
      DatabaseConstants.colUserVerificationStatus: VerificationStatus.verified.name,
      DatabaseConstants.colUserKtmUrl: null,
      DatabaseConstants.colUserMonthlyQuotaUsed: 2,
      DatabaseConstants.colUserMonthlyQuotaMax: 5,
      DatabaseConstants.colUserRejectionReason: null,
    });

    await db.insert(DatabaseConstants.tableUsers, {
      DatabaseConstants.colUserId: 'admin_1',
      DatabaseConstants.colUserEmail: 'admin@kampus.ac.id',
      DatabaseConstants.colUserRole: UserRole.admin.name,
      DatabaseConstants.colUserVerificationStatus: VerificationStatus.verified.name,
      DatabaseConstants.colUserKtmUrl: null,
      DatabaseConstants.colUserMonthlyQuotaUsed: 0,
      DatabaseConstants.colUserMonthlyQuotaMax: 5,
      DatabaseConstants.colUserRejectionReason: null,
    });

    final now = DateTime.now();
    final defaultMenfess = [
      {
        DatabaseConstants.colMenfessId: 'm1',
        DatabaseConstants.colMenfessCode: 'MNF-1042',
        DatabaseConstants.colMenfessCategory: MenfessCategory.sarpras.name,
        DatabaseConstants.colMenfessBody:
            'Kursi di ruang kuliah B203 banyak yang patah dan paku mencuat berbahaya. Tolong pihak sarpras segera cek sebelum ada yang terluka saat perkuliahan berlangsung.',
        DatabaseConstants.colMenfessAttachmentUrl:
            'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=600',
        DatabaseConstants.colMenfessAttachmentName:
            'Lampiran_B203_Kerusakan.jpg (1.2 MB)',
        DatabaseConstants.colMenfessStatus: MenfessStatus.pending.name,
        DatabaseConstants.colMenfessAllowInstagram: 1,
        DatabaseConstants.colMenfessIsAnonymous: 1,
        DatabaseConstants.colMenfessSupportCount: 38,
        DatabaseConstants.colMenfessReportCount: 0,
        DatabaseConstants.colMenfessCreatedAt:
            now.subtract(const Duration(minutes: 12)).toIso8601String(),
        DatabaseConstants.colMenfessReportReasonSummary: null,
        DatabaseConstants.colMenfessIsSensitive: 0,
      },
      {
        DatabaseConstants.colMenfessId: 'm2',
        DatabaseConstants.colMenfessCode: 'MNF-1038',
        DatabaseConstants.colMenfessCategory: MenfessCategory.akademik.name,
        DatabaseConstants.colMenfessBody:
            'Dosen mata kuliah Algoritma Pak B** tidak pernah masuk tapi tiba-tiba ngasih tugas deadline 2 jam di tengah malam. Sangat tidak masuk akal untuk kelas reguler.',
        DatabaseConstants.colMenfessAttachmentUrl: null,
        DatabaseConstants.colMenfessAttachmentName: null,
        DatabaseConstants.colMenfessStatus: MenfessStatus.pending.name,
        DatabaseConstants.colMenfessAllowInstagram: 0,
        DatabaseConstants.colMenfessIsAnonymous: 1,
        DatabaseConstants.colMenfessSupportCount: 28,
        DatabaseConstants.colMenfessReportCount: 3,
        DatabaseConstants.colMenfessCreatedAt:
            now.subtract(const Duration(minutes: 45)).toIso8601String(),
        DatabaseConstants.colMenfessReportReasonSummary:
            'Menyebut inisial dosen secara spesifik yang berpotensi melanggar pedoman etika digital kampus.',
        DatabaseConstants.colMenfessIsSensitive: 1,
      },
      {
        DatabaseConstants.colMenfessId: 'm3',
        DatabaseConstants.colMenfessCode: 'MNF-1045',
        DatabaseConstants.colMenfessCategory: MenfessCategory.sarpras.name,
        DatabaseConstants.colMenfessBody:
            'Kantin Fakultas Teknik tolong disediakan tempat sampah terpisah untuk organik dan anorganik. Saat ini sering meluber pas jam makan siang.',
        DatabaseConstants.colMenfessAttachmentUrl: null,
        DatabaseConstants.colMenfessAttachmentName: null,
        DatabaseConstants.colMenfessStatus: MenfessStatus.pending.name,
        DatabaseConstants.colMenfessAllowInstagram: 1,
        DatabaseConstants.colMenfessIsAnonymous: 1,
        DatabaseConstants.colMenfessSupportCount: 15,
        DatabaseConstants.colMenfessReportCount: 0,
        DatabaseConstants.colMenfessCreatedAt:
            now.subtract(const Duration(hours: 1)).toIso8601String(),
        DatabaseConstants.colMenfessReportReasonSummary: null,
        DatabaseConstants.colMenfessIsSensitive: 0,
      },
      {
        DatabaseConstants.colMenfessId: 'm4',
        DatabaseConstants.colMenfessCode: 'MNF-1020',
        DatabaseConstants.colMenfessCategory: MenfessCategory.layananIt.name,
        DatabaseConstants.colMenfessBody:
            'Wi-Fi di gedung C sering putus saat jam kuliah siang.',
        DatabaseConstants.colMenfessStatus: MenfessStatus.inProgress.name,
        DatabaseConstants.colMenfessAllowInstagram: 1,
        DatabaseConstants.colMenfessIsAnonymous: 1,
        DatabaseConstants.colMenfessSupportCount: 42,
        DatabaseConstants.colMenfessReportCount: 0,
        DatabaseConstants.colMenfessCreatedAt:
            now.subtract(const Duration(hours: 3)).toIso8601String(),
        DatabaseConstants.colMenfessReportReasonSummary: null,
        DatabaseConstants.colMenfessIsSensitive: 0,
      },
      {
        DatabaseConstants.colMenfessId: 'm5',
        DatabaseConstants.colMenfessCode: 'MNF-1015',
        DatabaseConstants.colMenfessCategory: MenfessCategory.sarpras.name,
        DatabaseConstants.colMenfessBody:
            'AC di ruang lab 3 tidak dingin sejak minggu lalu.',
        DatabaseConstants.colMenfessStatus: MenfessStatus.pending.name,
        DatabaseConstants.colMenfessAllowInstagram: 1,
        DatabaseConstants.colMenfessIsAnonymous: 1,
        DatabaseConstants.colMenfessSupportCount: 17,
        DatabaseConstants.colMenfessReportCount: 0,
        DatabaseConstants.colMenfessCreatedAt:
            now.subtract(const Duration(hours: 5)).toIso8601String(),
        DatabaseConstants.colMenfessReportReasonSummary: null,
        DatabaseConstants.colMenfessIsSensitive: 0,
      },
      {
        DatabaseConstants.colMenfessId: 'm6',
        DatabaseConstants.colMenfessCode: 'MNF-1011',
        DatabaseConstants.colMenfessCategory: MenfessCategory.keuangan.name,
        DatabaseConstants.colMenfessBody:
            'Alur pembayaran UKT sulit dipahami, mohon dibuatkan panduan singkat.',
        DatabaseConstants.colMenfessStatus: MenfessStatus.resolved.name,
        DatabaseConstants.colMenfessAllowInstagram: 1,
        DatabaseConstants.colMenfessIsAnonymous: 1,
        DatabaseConstants.colMenfessSupportCount: 68,
        DatabaseConstants.colMenfessReportCount: 0,
        DatabaseConstants.colMenfessCreatedAt:
            now.subtract(const Duration(days: 1)).toIso8601String(),
        DatabaseConstants.colMenfessReportReasonSummary: null,
        DatabaseConstants.colMenfessIsSensitive: 0,
      },
    ];

    for (final item in defaultMenfess) {
      await db.insert(DatabaseConstants.tableMenfess, item);
    }

    await db.insert(DatabaseConstants.tableDispositions, {
      DatabaseConstants.colDispId: 'd1',
      DatabaseConstants.colDispTicketCode: '#SK-8821',
      DatabaseConstants.colDispMenfessId: 'm1',
      DatabaseConstants.colDispUnit: 'Biro Sarana & Prasarana',
      DatabaseConstants.colDispUnitLocation: 'Gedung 3',
      DatabaseConstants.colDispStatus: 'Diproses',
      DatabaseConstants.colDispEstimateRemaining:
          'Estimasi respons tersisa: 2 hari kerja',
      DatabaseConstants.colDispIsOverdue: 0,
      DatabaseConstants.colDispMenfessQuote:
          'AC lab komputer gedung 3 bocor dan air merembes ke kabel stopkontak.',
      DatabaseConstants.colDispCorrespondenceDetail:
          'Terkirim ke email kabag_sarpras@kampus.ac.id pada 24 Okt. Menunggu konfirmasi pengerjaan fisik di lapangan.',
    });

    await db.insert(DatabaseConstants.tableDispositionLogs, {
      DatabaseConstants.colLogDispositionId: 'd1',
      DatabaseConstants.colLogTime: '24 Okt, 09:15',
      DatabaseConstants.colLogText: 'Tiket diterbitkan oleh Admin',
    });

    await db.insert(DatabaseConstants.tableDispositionLogs, {
      DatabaseConstants.colLogDispositionId: 'd1',
      DatabaseConstants.colLogTime: '24 Okt, 10:00',
      DatabaseConstants.colLogText: 'Email terkirim ke Biro Sarpras',
    });

    await db.insert(DatabaseConstants.tableDispositions, {
      DatabaseConstants.colDispId: 'd2',
      DatabaseConstants.colDispTicketCode: '#SK-8819',
      DatabaseConstants.colDispMenfessId: 'm4',
      DatabaseConstants.colDispUnit: 'Layanan IT & Jaringan',
      DatabaseConstants.colDispUnitLocation: 'Perpustakaan Lt. 2',
      DatabaseConstants.colDispStatus: 'Menunggu Respon',
      DatabaseConstants.colDispEstimateRemaining:
          'Telah melebihi 24 jam belum dibaca',
      DatabaseConstants.colDispIsOverdue: 1,
      DatabaseConstants.colDispMenfessQuote:
          'Koneksi Wi-Fi Eduroam di perpustakaan lantai 2 tidak bisa autentikasi sejak Senin.',
      DatabaseConstants.colDispCorrespondenceDetail:
          'Tiket terdistribusi otomatis via webhook kampus. Unit IT belum menetapkan PIC penanganan jaringan.',
    });

    await db.insert(DatabaseConstants.tableDispositionLogs, {
      DatabaseConstants.colLogDispositionId: 'd2',
      DatabaseConstants.colLogTime: '23 Okt, 14:00',
      DatabaseConstants.colLogText: 'Webhook terkirim ke IT helpdesk',
    });

    await db.insert(DatabaseConstants.tableInstagramPosts, {
      DatabaseConstants.colIgId: 'ig1',
      DatabaseConstants.colIgScheduleNumber: '#83',
      DatabaseConstants.colIgMenfessId: 'm6',
      DatabaseConstants.colIgScheduledTimeText: 'Hari ini, 19:00 WIB',
      DatabaseConstants.colIgFormat: 'Carousel (3/3)',
      DatabaseConstants.colIgQuoteText:
          'Alur pembayaran UKT via teller bank mitra sangat membingungkan, tolong..',
      DatabaseConstants.colIgCaption:
          'Sobat Kampus, ada masukan penting seputar alur teller UKT semester ini. Mari simak pembahasannya...\n\n#SuaraKampus #AspirasiMahasiswa #UKTKampus #Advokasi',
      DatabaseConstants.colIgFacultyTag: 'Fakultas Ekonomi',
      DatabaseConstants.colIgAutoPublish: 1,
      DatabaseConstants.colIgStatus: 'Terjadwal',
    });

    await db.insert(DatabaseConstants.tableInstagramPosts, {
      DatabaseConstants.colIgId: 'ig2',
      DatabaseConstants.colIgScheduleNumber: '#84',
      DatabaseConstants.colIgMenfessId: 'm4',
      DatabaseConstants.colIgScheduledTimeText: 'Besok, 12:00 WIB',
      DatabaseConstants.colIgFormat: 'Format Single Post',
      DatabaseConstants.colIgQuoteText:
          'Wi-Fi gedung C sering putus saat praktikum daring lab lantai 3. Mohon dicek.',
      DatabaseConstants.colIgCaption:
          'Pengaduan Sarana Prasarana: Masalah jaringan Wi-Fi di Gedung C sedang dalam penanganan unit terkait.',
      DatabaseConstants.colIgFacultyTag: 'Sarana Prasarana',
      DatabaseConstants.colIgAutoPublish: 1,
      DatabaseConstants.colIgStatus: 'Terjadwal',
    });

    await db.insert(DatabaseConstants.tableInstagramPosts, {
      DatabaseConstants.colIgId: 'ig3',
      DatabaseConstants.colIgScheduleNumber: '#85',
      DatabaseConstants.colIgMenfessId: 'm7',
      DatabaseConstants.colIgScheduledTimeText: '20:30 BESOK',
      DatabaseConstants.colIgFormat: 'Format Single Post + Siap Antre',
      DatabaseConstants.colIgQuoteText:
          'Jadwal Bus Kampus Malam sering tidak tepat waktu.',
      DatabaseConstants.colIgCaption:
          'Evaluasi transportasi internal kampus untuk rute malam.',
      DatabaseConstants.colIgFacultyTag: 'Transportasi',
      DatabaseConstants.colIgAutoPublish: 0,
      DatabaseConstants.colIgStatus: 'Draft Desain Feed',
    });
  }

  // -------------------------------------------------------------
  // USER CRUD
  // -------------------------------------------------------------
  Future<AppUser?> getUser(String id) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      return _webUsers[id];
    }
    final results = await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colUserId} = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return _userFromMap(results.first);
  }

  Future<void> upsertUser(AppUser user) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      _webUsers[user.id] = user;
      return;
    }
    await db.insert(
      DatabaseConstants.tableUsers,
      _userToMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------------------------------------------------
  // MENFESS CRUD
  // -------------------------------------------------------------
  Future<List<Menfess>> getMenfessList() async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      return List.unmodifiable(_webMenfess);
    }
    final results = await db.query(
      DatabaseConstants.tableMenfess,
      orderBy: '${DatabaseConstants.colMenfessCreatedAt} DESC',
    );
    return results.map(_menfessFromMap).toList();
  }

  Future<Menfess?> getMenfessById(String id) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      return _webMenfess.where((m) => m.id == id).firstOrNull;
    }
    final results = await db.query(
      DatabaseConstants.tableMenfess,
      where: '${DatabaseConstants.colMenfessId} = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return _menfessFromMap(results.first);
  }

  Future<void> insertMenfess(Menfess menfess) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      _webMenfess.removeWhere((m) => m.id == menfess.id);
      _webMenfess.insert(0, menfess);
      return;
    }
    await db.insert(
      DatabaseConstants.tableMenfess,
      _menfessToMap(menfess),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMenfess(Menfess menfess) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webMenfess.indexWhere((m) => m.id == menfess.id);
      if (idx != -1) _webMenfess[idx] = menfess;
      return;
    }
    await db.update(
      DatabaseConstants.tableMenfess,
      _menfessToMap(menfess),
      where: '${DatabaseConstants.colMenfessId} = ?',
      whereArgs: [menfess.id],
    );
  }

  Future<void> deleteMenfess(String id) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      _webMenfess.removeWhere((m) => m.id == id);
      return;
    }
    await db.delete(
      DatabaseConstants.tableMenfess,
      where: '${DatabaseConstants.colMenfessId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleSupport(String id) async {
    final isSupported = _supportedMenfessIds.contains(id);
    if (isSupported) {
      _supportedMenfessIds.remove(id);
    } else {
      _supportedMenfessIds.add(id);
    }
    final shouldAdd = !isSupported;

    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webMenfess.indexWhere((m) => m.id == id);
      if (idx != -1) {
        final current = _webMenfess[idx];
        final nextCount = shouldAdd
            ? current.supportCount + 1
            : (current.supportCount - 1).clamp(0, 999999);
        _webMenfess[idx] = current.copyWith(
          supportCount: nextCount,
          isSupportedByMe: shouldAdd,
        );
      }
      return;
    }

    if (shouldAdd) {
      await db.rawUpdate('''
        UPDATE ${DatabaseConstants.tableMenfess}
        SET ${DatabaseConstants.colMenfessSupportCount} = ${DatabaseConstants.colMenfessSupportCount} + 1
        WHERE ${DatabaseConstants.colMenfessId} = ?
      ''', [id]);
    } else {
      await db.rawUpdate('''
        UPDATE ${DatabaseConstants.tableMenfess}
        SET ${DatabaseConstants.colMenfessSupportCount} = MAX(0, ${DatabaseConstants.colMenfessSupportCount} - 1)
        WHERE ${DatabaseConstants.colMenfessId} = ?
      ''', [id]);
    }
  }

  Future<void> reportMenfess(String id, String reason) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webMenfess.indexWhere((m) => m.id == id);
      if (idx != -1) {
        final current = _webMenfess[idx];
        _webMenfess[idx] = current.copyWith(
          reportCount: current.reportCount + 1,
          reportReasonSummary: reason,
        );
      }
      return;
    }
    await db.rawUpdate('''
      UPDATE ${DatabaseConstants.tableMenfess}
      SET ${DatabaseConstants.colMenfessReportCount} = ${DatabaseConstants.colMenfessReportCount} + 1,
          ${DatabaseConstants.colMenfessReportReasonSummary} = ?
      WHERE ${DatabaseConstants.colMenfessId} = ?
    ''', [reason, id]);

    await db.insert(DatabaseConstants.tableReports, {
      DatabaseConstants.colReportId: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      DatabaseConstants.colReportMenfessId: id,
      DatabaseConstants.colReportReason: reason,
      DatabaseConstants.colReportCreatedAt: DateTime.now().toIso8601String(),
    });
  }

  Future<void> approveMenfess(String id) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webMenfess.indexWhere((m) => m.id == id);
      if (idx != -1) {
        _webMenfess[idx] = _webMenfess[idx].copyWith(status: MenfessStatus.approved);
      }
      return;
    }
    await db.update(
      DatabaseConstants.tableMenfess,
      {DatabaseConstants.colMenfessStatus: MenfessStatus.approved.name},
      where: '${DatabaseConstants.colMenfessId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> rejectMenfess(String id) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webMenfess.indexWhere((m) => m.id == id);
      if (idx != -1) {
        _webMenfess[idx] = _webMenfess[idx].copyWith(status: MenfessStatus.rejected);
      }
      return;
    }
    await db.update(
      DatabaseConstants.tableMenfess,
      {DatabaseConstants.colMenfessStatus: MenfessStatus.rejected.name},
      where: '${DatabaseConstants.colMenfessId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> censorMenfess(String id, String newBody) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webMenfess.indexWhere((m) => m.id == id);
      if (idx != -1) {
        _webMenfess[idx] = _webMenfess[idx].copyWith(
          body: newBody,
          isSensitive: false,
        );
      }
      return;
    }
    await db.update(
      DatabaseConstants.tableMenfess,
      {
        DatabaseConstants.colMenfessBody: newBody,
        DatabaseConstants.colMenfessIsSensitive: 0,
      },
      where: '${DatabaseConstants.colMenfessId} = ?',
      whereArgs: [id],
    );
  }

  // -------------------------------------------------------------
  // DISPOSITIONS CRUD
  // -------------------------------------------------------------
  Future<List<Disposition>> getDispositions() async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      return List.unmodifiable(_webDispositions);
    }
    final dispRows = await db.query(DatabaseConstants.tableDispositions);

    final List<Disposition> result = [];
    for (final row in dispRows) {
      final dispId = row[DatabaseConstants.colDispId] as String;
      final logRows = await db.query(
        DatabaseConstants.tableDispositionLogs,
        where: '${DatabaseConstants.colLogDispositionId} = ?',
        whereArgs: [dispId],
      );

      final logs = logRows
          .map((l) => DispositionLog(
                time: l[DatabaseConstants.colLogTime] as String,
                text: l[DatabaseConstants.colLogText] as String,
              ))
          .toList();

      result.add(Disposition(
        id: dispId,
        ticketCode: row[DatabaseConstants.colDispTicketCode] as String,
        menfessId: row[DatabaseConstants.colDispMenfessId] as String,
        unit: row[DatabaseConstants.colDispUnit] as String,
        unitLocation: row[DatabaseConstants.colDispUnitLocation] as String,
        status: row[DatabaseConstants.colDispStatus] as String,
        estimateRemaining:
            row[DatabaseConstants.colDispEstimateRemaining] as String,
        isOverdue: (row[DatabaseConstants.colDispIsOverdue] as int) == 1,
        menfessQuote: row[DatabaseConstants.colDispMenfessQuote] as String,
        correspondenceDetail:
            row[DatabaseConstants.colDispCorrespondenceDetail] as String?,
        logs: logs,
      ));
    }
    return result;
  }

  Future<void> updateDispositionStatus(String id, String status) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webDispositions.indexWhere((d) => d.id == id);
      if (idx != -1) {
        _webDispositions[idx] = _webDispositions[idx].copyWith(status: status, isOverdue: false);
      }
      return;
    }
    await db.update(
      DatabaseConstants.tableDispositions,
      {
        DatabaseConstants.colDispStatus: status,
        DatabaseConstants.colDispIsOverdue: 0,
      },
      where: '${DatabaseConstants.colDispId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> addDispositionLog(String dispId, String time, String text) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webDispositions.indexWhere((d) => d.id == dispId);
      if (idx != -1) {
        final current = _webDispositions[idx];
        _webDispositions[idx] = current.copyWith(
          logs: [...current.logs, DispositionLog(time: time, text: text)],
        );
      }
      return;
    }
    await db.insert(DatabaseConstants.tableDispositionLogs, {
      DatabaseConstants.colLogDispositionId: dispId,
      DatabaseConstants.colLogTime: time,
      DatabaseConstants.colLogText: text,
    });
  }

  // -------------------------------------------------------------
  // INSTAGRAM POSTS CRUD
  // -------------------------------------------------------------
  Future<List<InstagramPost>> getInstagramPosts() async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      return List.unmodifiable(_webInstagramPosts);
    }
    final results = await db.query(DatabaseConstants.tableInstagramPosts);
    return results
        .map((row) => InstagramPost(
              id: row[DatabaseConstants.colIgId] as String,
              scheduleNumber:
                  row[DatabaseConstants.colIgScheduleNumber] as String,
              menfessId: row[DatabaseConstants.colIgMenfessId] as String,
              scheduledTimeText:
                  row[DatabaseConstants.colIgScheduledTimeText] as String,
              format: row[DatabaseConstants.colIgFormat] as String,
              quoteText: row[DatabaseConstants.colIgQuoteText] as String,
              caption: row[DatabaseConstants.colIgCaption] as String,
              facultyTag: row[DatabaseConstants.colIgFacultyTag] as String,
              autoPublish:
                  (row[DatabaseConstants.colIgAutoPublish] as int) == 1,
              status: row[DatabaseConstants.colIgStatus] as String,
            ))
        .toList();
  }

  Future<void> toggleInstagramAutoPublish(String id, bool autoPublish) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      final idx = _webInstagramPosts.indexWhere((p) => p.id == id);
      if (idx != -1) {
        _webInstagramPosts[idx] = _webInstagramPosts[idx].copyWith(autoPublish: autoPublish);
      }
      return;
    }
    await db.update(
      DatabaseConstants.tableInstagramPosts,
      {DatabaseConstants.colIgAutoPublish: autoPublish ? 1 : 0},
      where: '${DatabaseConstants.colIgId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertInstagramPost(InstagramPost post) async {
    final db = await database;
    if (db == null || _isWebFallback) {
      _initWebFallback();
      _webInstagramPosts.removeWhere((p) => p.id == post.id);
      _webInstagramPosts.add(post);
      return;
    }
    await db.insert(
      DatabaseConstants.tableInstagramPosts,
      {
        DatabaseConstants.colIgId: post.id,
        DatabaseConstants.colIgScheduleNumber: post.scheduleNumber,
        DatabaseConstants.colIgMenfessId: post.menfessId,
        DatabaseConstants.colIgScheduledTimeText: post.scheduledTimeText,
        DatabaseConstants.colIgFormat: post.format,
        DatabaseConstants.colIgQuoteText: post.quoteText,
        DatabaseConstants.colIgCaption: post.caption,
        DatabaseConstants.colIgFacultyTag: post.facultyTag,
        DatabaseConstants.colIgAutoPublish: post.autoPublish ? 1 : 0,
        DatabaseConstants.colIgStatus: post.status,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------------------------------------------------
  // MAPPER HELPERS
  // -------------------------------------------------------------
  AppUser _userFromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map[DatabaseConstants.colUserId] as String,
      email: map[DatabaseConstants.colUserEmail] as String,
      role: UserRole.values.byName(map[DatabaseConstants.colUserRole] as String),
      verificationStatus: VerificationStatus.values.byName(
          map[DatabaseConstants.colUserVerificationStatus] as String),
      ktmUrl: map[DatabaseConstants.colUserKtmUrl] as String?,
      monthlyQuotaUsed:
          map[DatabaseConstants.colUserMonthlyQuotaUsed] as int? ?? 0,
      monthlyQuotaMax:
          map[DatabaseConstants.colUserMonthlyQuotaMax] as int? ?? 5,
      rejectionReason:
          map[DatabaseConstants.colUserRejectionReason] as String?,
    );
  }

  Map<String, dynamic> _userToMap(AppUser user) {
    return {
      DatabaseConstants.colUserId: user.id,
      DatabaseConstants.colUserEmail: user.email,
      DatabaseConstants.colUserRole: user.role.name,
      DatabaseConstants.colUserVerificationStatus: user.verificationStatus.name,
      DatabaseConstants.colUserKtmUrl: user.ktmUrl,
      DatabaseConstants.colUserMonthlyQuotaUsed: user.monthlyQuotaUsed,
      DatabaseConstants.colUserMonthlyQuotaMax: user.monthlyQuotaMax,
      DatabaseConstants.colUserRejectionReason: user.rejectionReason,
    };
  }

  Menfess _menfessFromMap(Map<String, dynamic> map) {
    return Menfess(
      id: map[DatabaseConstants.colMenfessId] as String,
      code: map[DatabaseConstants.colMenfessCode] as String,
      category: MenfessCategory.values
          .byName(map[DatabaseConstants.colMenfessCategory] as String),
      body: map[DatabaseConstants.colMenfessBody] as String,
      attachmentUrl:
          map[DatabaseConstants.colMenfessAttachmentUrl] as String?,
      attachmentName:
          map[DatabaseConstants.colMenfessAttachmentName] as String?,
      status: MenfessStatus.values
          .byName(map[DatabaseConstants.colMenfessStatus] as String),
      allowInstagram:
          (map[DatabaseConstants.colMenfessAllowInstagram] as int) == 1,
      isAnonymous: (map[DatabaseConstants.colMenfessIsAnonymous] as int) == 1,
      supportCount:
          map[DatabaseConstants.colMenfessSupportCount] as int? ?? 0,
      reportCount: map[DatabaseConstants.colMenfessReportCount] as int? ?? 0,
      createdAt: DateTime.parse(
          map[DatabaseConstants.colMenfessCreatedAt] as String),
      reportReasonSummary:
          map[DatabaseConstants.colMenfessReportReasonSummary] as String?,
      isSensitive: (map[DatabaseConstants.colMenfessIsSensitive] as int) == 1,
      isSupportedByMe:
          _supportedMenfessIds.contains(map[DatabaseConstants.colMenfessId]),
    );
  }

  Map<String, dynamic> _menfessToMap(Menfess m) {
    return {
      DatabaseConstants.colMenfessId: m.id,
      DatabaseConstants.colMenfessCode: m.code,
      DatabaseConstants.colMenfessCategory: m.category.name,
      DatabaseConstants.colMenfessBody: m.body,
      DatabaseConstants.colMenfessAttachmentUrl: m.attachmentUrl,
      DatabaseConstants.colMenfessAttachmentName: m.attachmentName,
      DatabaseConstants.colMenfessStatus: m.status.name,
      DatabaseConstants.colMenfessAllowInstagram: m.allowInstagram ? 1 : 0,
      DatabaseConstants.colMenfessIsAnonymous: m.isAnonymous ? 1 : 0,
      DatabaseConstants.colMenfessSupportCount: m.supportCount,
      DatabaseConstants.colMenfessReportCount: m.reportCount,
      DatabaseConstants.colMenfessCreatedAt: m.createdAt.toIso8601String(),
      DatabaseConstants.colMenfessReportReasonSummary: m.reportReasonSummary,
      DatabaseConstants.colMenfessIsSensitive: m.isSensitive ? 1 : 0,
    };
  }
}
