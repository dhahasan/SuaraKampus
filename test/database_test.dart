import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:suara_kampus/core/data/sqlite_repository.dart';
import 'package:suara_kampus/core/database/app_database.dart';
import 'package:suara_kampus/core/models/app_models.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SuaraKampus SQLite Database & Repository Tests', () {
    test('Database initializes and seeds initial records correctly', () async {
      final db = AppDatabase.instance;
      await db.init();

      final users = await db.getUser('user_1');
      expect(users, isNotNull);
      expect(users!.email, '2110511042@mahasiswa.kampus.ac.id');
      expect(users.role, UserRole.student);
      expect(users.verificationStatus, VerificationStatus.verified);

      final admin = await db.getUser('admin_1');
      expect(admin, isNotNull);
      expect(admin!.role, UserRole.admin);

      final menfessList = await db.getMenfessList();
      expect(menfessList.length, greaterThanOrEqualTo(6));
      expect(menfessList.any((m) => m.code == 'MNF-1042'), isTrue);

      final dispositions = await db.getDispositions();
      expect(dispositions.length, greaterThanOrEqualTo(2));
      expect(dispositions.first.ticketCode, '#SK-8821');

      final igPosts = await db.getInstagramPosts();
      expect(igPosts.length, greaterThanOrEqualTo(3));
      expect(igPosts.first.scheduleNumber, '#83');
    });

    test('Menfess CRUD and actions work as expected', () async {
      final repo = SqliteRepository();

      // Add new Menfess
      final newMenfess = Menfess(
        id: 'test_m1',
        code: 'MNF-9999',
        category: MenfessCategory.akademik,
        body: 'Testing database integration for SuaraKampus',
        status: MenfessStatus.pending,
        allowInstagram: true,
        isAnonymous: true,
        supportCount: 0,
        reportCount: 0,
        createdAt: DateTime.now(),
      );

      await repo.addMenfess(newMenfess);

      var fetched = await repo.getMenfessById('test_m1');
      expect(fetched, isNotNull);
      expect(fetched!.body, 'Testing database integration for SuaraKampus');

      // Toggle Support (Like -> supportCount = 1)
      await repo.toggleSupport('test_m1');
      fetched = await repo.getMenfessById('test_m1');
      expect(fetched!.supportCount, 1);

      // Toggle Support kembali (Unlike -> supportCount = 0)
      await repo.toggleSupport('test_m1');
      fetched = await repo.getMenfessById('test_m1');
      expect(fetched!.supportCount, 0);

      // Report
      await repo.reportMenfess('test_m1', 'Uji coba laporan');
      fetched = await repo.getMenfessById('test_m1');
      expect(fetched!.reportCount, 1);
      expect(fetched.reportReasonSummary, 'Uji coba laporan');

      // Approve
      await repo.approveMenfess('test_m1');
      fetched = await repo.getMenfessById('test_m1');
      expect(fetched!.status, MenfessStatus.approved);

      // Censor
      await repo.censorText('test_m1', 'Dosen *** yang terhormat');
      fetched = await repo.getMenfessById('test_m1');
      expect(fetched!.body, 'Dosen *** yang terhormat');

      // Delete
      await repo.deleteMenfess('test_m1');
      fetched = await repo.getMenfessById('test_m1');
      expect(fetched, isNull);
    });

    test('Disposition actions persist correctly', () async {
      final repo = SqliteRepository();

      await repo.sendDispositionReminder('d1');
      var list = await repo.getDispositions();
      final d1 = list.firstWhere((d) => d.id == 'd1');
      expect(d1.logs.any((l) => l.text.contains('Pengingat')), isTrue);

      await repo.markDispositionResolved('d1');
      list = await repo.getDispositions();
      final d1Resolved = list.firstWhere((d) => d.id == 'd1');
      expect(d1Resolved.status, 'Selesai');
    });

    test('Analytics summary calculates properly', () async {
      final repo = SqliteRepository();
      final analytics = await repo.getAnalytics();

      expect(analytics.total, greaterThan(0));
      expect(analytics.weeklyTrend.length, 4);
      expect(analytics.categoryDistribution.length, 4);
      expect(analytics.unitPerformance.length, 3);
    });
  });
}
