import '../models/app_models.dart';
import '../network/api_constants.dart';
import '../network/api_service.dart';

class DatabaseRepository {
  final ApiService _apiService = ApiService();

  // Test koneksi ke database MySQL
  Future<ApiResponse<Map<String, dynamic>>> testDatabaseConnection() async {
    final response = await _apiService.get(ApiConstants.test);
    if (response.isSuccess && response.data is Map<String, dynamic>) {
      return ApiResponse.success(response.data as Map<String, dynamic>);
    }
    return ApiResponse.error(
      response.message ?? 'Tidak dapat terhubung ke MySQL.',
    );
  }

  // Auth: Login
  Future<ApiResponse<AppUser>> login(String email, String password) async {
    final response = await _apiService.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );

    if (response.isSuccess && response.data is Map<String, dynamic>) {
      return ApiResponse.success(
        AppUser.fromJson(response.data as Map<String, dynamic>),
      );
    }
    return ApiResponse.error(response.message ?? 'Gagal masuk.');
  }

  // Auth: Register
  Future<ApiResponse<AppUser>> register(
    String email,
    String password, {
    String role = 'student',
  }) async {
    final response = await _apiService.post(
      ApiConstants.register,
      body: {'email': email, 'password': password, 'role': role},
    );

    if (response.isSuccess && response.data is Map<String, dynamic>) {
      return ApiResponse.success(
        AppUser.fromJson(response.data as Map<String, dynamic>),
      );
    }
    return ApiResponse.error(response.message ?? 'Gagal mendaftar.');
  }

  // Auth: Verifikasi Akun / Foto KTM
  Future<ApiResponse<AppUser>> updateVerification({
    required String userId,
    required VerificationStatus status,
    String? ktmUrl,
    String? rejectionReason,
  }) async {
    final response = await _apiService.post(
      ApiConstants.verifyKtm,
      body: {
        'userId': userId,
        'status': status.name,
        'ktmUrl': ktmUrl,
        'rejectionReason': rejectionReason,
      },
    );

    if (response.isSuccess && response.data is Map<String, dynamic>) {
      return ApiResponse.success(
        AppUser.fromJson(response.data as Map<String, dynamic>),
      );
    }
    return ApiResponse.error(
      response.message ?? 'Gagal memperbarui verifikasi.',
    );
  }

  // Menfess: Ambil data dari database
  Future<ApiResponse<List<Menfess>>> getMenfessList({
    String? category,
    String? status,
  }) async {
    final Map<String, String> params = {};
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (status != null && status.isNotEmpty) params['status'] = status;

    final response = await _apiService.get(
      ApiConstants.menfess,
      queryParams: params,
    );
    if (response.isSuccess && response.data is List) {
      final list = (response.data as List)
          .map((item) => Menfess.fromJson(item as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(list);
    }
    return ApiResponse.error(
      response.message ?? 'Gagal mengambil data aspirasi.',
    );
  }

  // Menfess: Kirim aspirasi baru ke database
  Future<ApiResponse<Menfess>> createMenfess({
    required String userId,
    required MenfessCategory category,
    required String body,
    String? attachmentUrl,
    String? attachmentName,
    bool allowInstagram = true,
    bool isAnonymous = true,
  }) async {
    final response = await _apiService.post(
      ApiConstants.menfess,
      body: {
        'userId': userId,
        'category': category.name,
        'body': body,
        'attachmentUrl': attachmentUrl,
        'attachmentName': attachmentName,
        'allowInstagram': allowInstagram,
        'isAnonymous': isAnonymous,
      },
    );

    if (response.isSuccess && response.data is Map<String, dynamic>) {
      return ApiResponse.success(
        Menfess.fromJson(response.data as Map<String, dynamic>),
      );
    }
    return ApiResponse.error(
      response.message ?? 'Gagal mengirim menfess ke database.',
    );
  }

  // Menfess: Tambah dukungan "Saya juga"
  Future<ApiResponse<int>> supportMenfess(
    String menfessId, {
    String? userId,
  }) async {
    final response = await _apiService.post(
      ApiConstants.supportMenfess,
      body: {'menfessId': menfessId, 'userId': userId},
    );

    if (response.isSuccess && response.data is Map<String, dynamic>) {
      return ApiResponse.success(
        (response.data['supportCount'] as num).toInt(),
      );
    }
    return ApiResponse.error(response.message ?? 'Gagal memberi dukungan.');
  }

  // Menfess: Moderasi Admin (approve, reject, censor, delete)
  Future<ApiResponse<dynamic>> moderateMenfess(
    String menfessId,
    String action,
  ) async {
    final response = await _apiService.post(
      ApiConstants.moderateMenfess,
      body: {'menfessId': menfessId, 'action': action},
    );
    return response;
  }

  // Menfess: Laporkan aspirasi
  Future<ApiResponse<String>> reportMenfess(
    String menfessId,
    String reason,
  ) async {
    final response = await _apiService.post(
      ApiConstants.reports,
      body: {'menfessId': menfessId, 'reason': reason},
    );
    if (response.isSuccess) {
      return ApiResponse.success(response.message ?? 'Laporan terkirim.');
    }
    return ApiResponse.error(response.message ?? 'Gagal mengirim laporan.');
  }

  // Admin: Ambil Disposisi
  Future<ApiResponse<List<Disposition>>> getDispositions() async {
    final response = await _apiService.get(ApiConstants.dispositions);
    if (response.isSuccess && response.data is List) {
      final list = (response.data as List)
          .map((item) => Disposition.fromJson(item as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(list);
    }
    return ApiResponse.error(
      response.message ?? 'Gagal memuat daftar disposisi.',
    );
  }

  // Admin: Tindak Lanjut Disposisi (resolve / reminder)
  Future<ApiResponse<dynamic>> updateDisposition(
    String id,
    String action,
  ) async {
    return await _apiService.post(
      ApiConstants.dispositions,
      body: {'id': id, 'action': action},
    );
  }

  // Admin: Antrean Instagram
  Future<ApiResponse<List<InstagramPost>>> getInstagramQueue() async {
    final response = await _apiService.get(ApiConstants.instagram);
    if (response.isSuccess && response.data is List) {
      final list = (response.data as List)
          .map((item) => InstagramPost.fromJson(item as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(list);
    }
    return ApiResponse.error(
      response.message ?? 'Gagal memuat antrean Instagram.',
    );
  }

  // Admin: Toggle Auto Publish Instagram
  Future<ApiResponse<dynamic>> toggleInstagramAutoPublish(String id) async {
    return await _apiService.post(
      ApiConstants.instagram,
      body: {'id': id, 'action': 'toggle'},
    );
  }

  // Admin: Generate Instagram Batch
  Future<ApiResponse<dynamic>> generateInstagramBatch() async {
    return await _apiService.post(
      ApiConstants.instagram,
      body: {'action': 'generate'},
    );
  }

  // Admin: Analitik Dashboard
  Future<ApiResponse<AnalyticsSummary>> getAnalytics() async {
    final response = await _apiService.get(ApiConstants.analytics);
    if (response.isSuccess && response.data is Map<String, dynamic>) {
      return ApiResponse.success(
        AnalyticsSummary.fromJson(response.data as Map<String, dynamic>),
      );
    }
    return ApiResponse.error(response.message ?? 'Gagal memuat data analitik.');
  }

  // Upload file (KTM / Lampiran)
  Future<ApiResponse<String>> uploadFile(String filePath) async {
    return await _apiService.uploadFile(
      ApiConstants.upload,
      filePath: filePath,
      fieldName: 'file',
    );
  }
}
