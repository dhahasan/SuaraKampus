import '../models/app_models.dart';

abstract class AppRepository {
  // User methods
  Future<AppUser?> getCurrentUser(String id);
  Future<void> saveUser(AppUser user);

  // Menfess methods
  Future<List<Menfess>> getMenfessList();
  Future<Menfess?> getMenfessById(String id);
  Future<void> addMenfess(Menfess menfess);
  Future<void> toggleSupport(String id);
  Future<void> reportMenfess(String id, String reason);
  Future<void> approveMenfess(String id);
  Future<void> rejectMenfess(String id);
  Future<void> censorText(String id, String newBody);
  Future<void> deleteMenfess(String id);

  // Disposition methods
  Future<List<Disposition>> getDispositions();
  Future<void> markDispositionResolved(String id);
  Future<void> sendDispositionReminder(String id);

  // Instagram Post methods
  Future<List<InstagramPost>> getInstagramPosts();
  Future<void> toggleInstagramAutoPublish(String id, bool autoPublish);
  Future<void> addInstagramPost(InstagramPost post);

  // Analytics
  Future<AnalyticsSummary> getAnalytics();
}

