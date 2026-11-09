import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final AppUser? user;

  const AuthResult.success(this.user)
      : isSuccess = true,
        errorMessage = null;

  const AuthResult.failure(this.errorMessage)
      : isSuccess = false,
        user = null;
}

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  // Registry kredensial akun valid
  final Map<String, String> _credentials = {
    'admin@kampus.ac.id': 'admin123',
    'mahasiswa@kampus.ac.id': 'kampus123',
    '2110511042@mahasiswa.kampus.ac.id': 'kampus123',
  };

  // Registry profil pengguna
  final Map<String, AppUser> _users = {
    'admin@kampus.ac.id': const AppUser(
      id: 'admin_1',
      email: 'admin@kampus.ac.id',
      role: UserRole.admin,
      verificationStatus: VerificationStatus.verified,
      monthlyQuotaUsed: 0,
      monthlyQuotaMax: 5,
    ),
    'mahasiswa@kampus.ac.id': const AppUser(
      id: 'user_1',
      email: 'mahasiswa@kampus.ac.id',
      role: UserRole.student,
      verificationStatus: VerificationStatus.verified,
      monthlyQuotaUsed: 2,
      monthlyQuotaMax: 5,
    ),
    '2110511042@mahasiswa.kampus.ac.id': const AppUser(
      id: 'user_1',
      email: '2110511042@mahasiswa.kampus.ac.id',
      role: UserRole.student,
      verificationStatus: VerificationStatus.verified,
      monthlyQuotaUsed: 2,
      monthlyQuotaMax: 5,
    ),
  };

  Map<String, String> get validCredentials => Map.unmodifiable(_credentials);

  /// Validasi Login: kata sandi WAJIB cocok
  AuthResult validateLogin({
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password;

    if (cleanEmail.isEmpty) {
      return const AuthResult.failure('Email tidak boleh kosong.');
    }

    if (cleanPassword.isEmpty) {
      return const AuthResult.failure('Kata sandi tidak boleh kosong.');
    }

    // Periksa apakah email terdaftar
    final expectedPassword = _credentials[cleanEmail];
    if (expectedPassword == null) {
      return const AuthResult.failure('Email tidak terdaftar di sistem kampus.');
    }

    // Validasi kata sandi secara ketat
    if (cleanPassword != expectedPassword) {
      return const AuthResult.failure('Kata sandi salah. Silakan coba lagi.');
    }

    final user = _users[cleanEmail] ??
        AppUser(
          id: 'user_${cleanEmail.hashCode}',
          email: cleanEmail,
          role: cleanEmail.contains('admin') ? UserRole.admin : UserRole.student,
          verificationStatus: VerificationStatus.verified,
          monthlyQuotaUsed: 2,
          monthlyQuotaMax: 5,
        );

    return AuthResult.success(user);
  }

  /// Pendaftaran akun mahasiswa baru
  AuthResult register({
    required String email,
    required String password,
    required String confirmPassword,
    required bool agreementChecked,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password;
    final cleanConfirm = confirmPassword;

    if (cleanEmail.isEmpty) {
      return const AuthResult.failure('Email tidak boleh kosong.');
    }

    if (!cleanEmail.contains('@') ||
        (!cleanEmail.endsWith('.ac.id') && !cleanEmail.contains('.ac.id'))) {
      return const AuthResult.failure(
        'Gunakan domain email kampus yang valid (harus mengandung .ac.id).',
      );
    }

    if (cleanPassword.length < 8) {
      return const AuthResult.failure(
        'Kata sandi minimal 8 karakter.',
      );
    }

    if (cleanPassword != cleanConfirm) {
      return const AuthResult.failure(
        'Ulangi kata sandi tidak cocok dengan kata sandi.',
      );
    }

    if (!agreementChecked) {
      return const AuthResult.failure(
        'Harap setujui aturan penggunaan untuk melanjutkan.',
      );
    }

    if (_credentials.containsKey(cleanEmail)) {
      return const AuthResult.failure(
        'Email ini sudah terdaftar. Silakan masuk pada tab Masuk.',
      );
    }

    final newUser = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: cleanEmail,
      role: cleanEmail.contains('admin') ? UserRole.admin : UserRole.student,
      verificationStatus: VerificationStatus.pending,
      monthlyQuotaUsed: 0,
      monthlyQuotaMax: 5,
    );

    _credentials[cleanEmail] = cleanPassword;
    _users[cleanEmail] = newUser;

    return AuthResult.success(newUser);
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService.instance);

