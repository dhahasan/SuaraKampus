import 'package:flutter_test/flutter_test.dart';
import 'package:suara_kampus/core/data/auth_service.dart';
import 'package:suara_kampus/core/models/app_models.dart';

void main() {
  group('AuthService Tests', () {
    final auth = AuthService.instance;

    test('Login dengan kata sandi salah harus GAGAL dan mengembalikan pesan error', () {
      final result = auth.validateLogin(
        email: 'mahasiswa@kampus.ac.id',
        password: 'password_salah_123',
      );

      expect(result.isSuccess, isFalse);
      expect(result.user, isNull);
      expect(result.errorMessage, 'Kata sandi salah. Silakan coba lagi.');
    });

    test('Login dengan kata sandi benar untuk mahasiswa harus BERHASIL', () {
      final result = auth.validateLogin(
        email: 'mahasiswa@kampus.ac.id',
        password: 'kampus123',
      );

      expect(result.isSuccess, isTrue);
      expect(result.user, isNotNull);
      expect(result.user!.role, UserRole.student);
      expect(result.user!.email, 'mahasiswa@kampus.ac.id');
    });

    test('Login dengan kata sandi benar untuk admin harus BERHASIL', () {
      final result = auth.validateLogin(
        email: 'admin@kampus.ac.id',
        password: 'admin123',
      );

      expect(result.isSuccess, isTrue);
      expect(result.user, isNotNull);
      expect(result.user!.role, UserRole.admin);
    });

    test('Login dengan email kosong harus GAGAL', () {
      final result = auth.validateLogin(
        email: '',
        password: 'kampus123',
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, 'Email tidak boleh kosong.');
    });

    test('Login dengan kata sandi kosong harus GAGAL', () {
      final result = auth.validateLogin(
        email: 'mahasiswa@kampus.ac.id',
        password: '',
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, 'Kata sandi tidak boleh kosong.');
    });

    test('Login dengan email yang belum terdaftar harus GAGAL', () {
      final result = auth.validateLogin(
        email: 'orang_asing@gmail.com',
        password: 'bebas12345',
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, 'Email tidak terdaftar di sistem kampus.');
    });

    test('Pendaftaran akun baru memvalidasi format email, sandi min 8 karakter, dan kesesuaian konfirmasi', () {
      // Sandi kurang dari 8 karakter
      var regResult = auth.register(
        email: 'mhsbaru@mahasiswa.kampus.ac.id',
        password: 'pendek',
        confirmPassword: 'pendek',
        agreementChecked: true,
      );
      expect(regResult.isSuccess, isFalse);
      expect(regResult.errorMessage, 'Kata sandi minimal 8 karakter.');

      // Konfirmasi tidak cocok
      regResult = auth.register(
        email: 'mhsbaru@mahasiswa.kampus.ac.id',
        password: 'password123',
        confirmPassword: 'password999',
        agreementChecked: true,
      );
      expect(regResult.isSuccess, isFalse);
      expect(regResult.errorMessage, 'Ulangi kata sandi tidak cocok dengan kata sandi.');

      // Domain bukan kampus (.ac.id)
      regResult = auth.register(
        email: 'mhsbaru@yahoo.com',
        password: 'password123',
        confirmPassword: 'password123',
        agreementChecked: true,
      );
      expect(regResult.isSuccess, isFalse);
      expect(regResult.errorMessage, contains('.ac.id'));

      // Pendaftaran berhasil
      regResult = auth.register(
        email: 'mhsbaru@mahasiswa.kampus.ac.id',
        password: 'password123',
        confirmPassword: 'password123',
        agreementChecked: true,
      );
      expect(regResult.isSuccess, isTrue);
      expect(regResult.user!.verificationStatus, VerificationStatus.pending);

      // Setelah daftar, login dengan kata sandi salah harus GAGAL
      final loginFail = auth.validateLogin(
        email: 'mhsbaru@mahasiswa.kampus.ac.id',
        password: 'sandi_salah',
      );
      expect(loginFail.isSuccess, isFalse);
      expect(loginFail.errorMessage, 'Kata sandi salah. Silakan coba lagi.');

      // Login dengan kata sandi benar harus BERHASIL
      final loginOk = auth.validateLogin(
        email: 'mhsbaru@mahasiswa.kampus.ac.id',
        password: 'password123',
      );
      expect(loginOk.isSuccess, isTrue);
      expect(loginOk.user!.email, 'mhsbaru@mahasiswa.kampus.ac.id');
    });
  });
}

