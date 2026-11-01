import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/info_banner.dart';

class AuthTabScreen extends ConsumerStatefulWidget {
  final int initialTabIndex; // 0: Masuk, 1: Daftar

  const AuthTabScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<AuthTabScreen> createState() => _AuthTabScreenState();
}

class _AuthTabScreenState extends ConsumerState<AuthTabScreen> {
  late int _selectedTab;

  // Masuk controllers
  final _masukEmailController =
      TextEditingController(text: 'mahasiswa@kampus.ac.id');
  final _masukPasswordController = TextEditingController(text: 'rahasia123');
  bool _masukObscure = true;

  // Daftar controllers
  final _daftarEmailController =
      TextEditingController(text: '2110511042@mahasiswa.kampus.ac.id');
  final _daftarPasswordController = TextEditingController(text: 'password1234');
  final _daftarConfirmPasswordController =
      TextEditingController(text: 'password1234');
  bool _daftarObscure = true;
  bool _daftarConfirmObscure = true;
  bool _agreementChecked = true;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _masukEmailController.dispose();
    _masukPasswordController.dispose();
    _daftarEmailController.dispose();
    _daftarPasswordController.dispose();
    _daftarConfirmPasswordController.dispose();
    super.dispose();
  }

  void _submitMasuk() {
    final email = _masukEmailController.text.trim();
    if (email.contains('admin')) {
      ref.read(currentUserProvider.notifier).setUser(
            AppUser(
              id: 'admin_1',
              email: email,
              role: UserRole.admin,
              verificationStatus: VerificationStatus.verified,
            ),
          );
      context.go('/admin/moderasi');
    } else {
      ref.read(currentUserProvider.notifier).setUser(
            AppUser(
              id: 'user_1',
              email: email.isEmpty ? 'mahasiswa@kampus.ac.id' : email,
              role: UserRole.student,
              verificationStatus: VerificationStatus.verified,
              monthlyQuotaUsed: 2,
              monthlyQuotaMax: 5,
            ),
          );
      context.go('/feed');
    }
  }

  void _submitDaftar() {
    final email = _daftarEmailController.text.trim();
    ref.read(currentUserProvider.notifier).setUser(
          AppUser(
            id: 'user_new',
            email: email.isEmpty ? '2110511042@mahasiswa.kampus.ac.id' : email,
            role: UserRole.student,
            verificationStatus: VerificationStatus.pending,
            monthlyQuotaUsed: 0,
            monthlyQuotaMax: 5,
          ),
        );
    context.go('/auth/verifikasi-menunggu');
  }

  @override
  Widget build(BuildContext context) {
    final isDaftar = _selectedTab == 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Kiri
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.forum_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SuaraKampus',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Portal Aspirasi Mahasiswa',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Segmented Tab 2 Sisi: Masuk | Daftar
              Container(
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F0F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderCard, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: !isDaftar ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: !isDaftar
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: !isDaftar
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: !isDaftar
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isDaftar ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isDaftar
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isDaftar
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isDaftar
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Form content
              if (!isDaftar) ...[
                // TAB MASUK (3.4)
                AppTextField(
                  label: 'Email Kampus',
                  hintText: 'mahasiswa@kampus.ac.id',
                  controller: _masukEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Kata Sandi',
                  hintText: '••••••••',
                  controller: _masukPasswordController,
                  obscureText: _masukObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _masukObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _masukObscure = !_masukObscure;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Lupa sandi?',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Masuk',
                  width: double.infinity,
                  height: 44,
                  onPressed: _submitMasuk,
                ),
                const SizedBox(height: 18),
                const InfoBanner(
                  message:
                      'Privasi Terjaga: Namamu tidak ditampilkan di publik. Admin hanya melihat email yang kamu daftarkan.',
                  icon: Icons.shield_outlined,
                  type: InfoBannerType.info,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: const Text(
                          'Daftar sekarang',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // TAB DAFTAR (3.3)
                AppTextField(
                  label: 'Email/Nomor Kampus',
                  hintText: '2110511042@mahasiswa.kampus.ac.id',
                  controller: _daftarEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gunakan domain email kampus yang valid',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Kata Sandi',
                  hintText: 'password1234',
                  controller: _daftarPasswordController,
                  obscureText: _daftarObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _daftarObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _daftarObscure = !_daftarObscure;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Ulangi Kata Sandi',
                  hintText: 'password1234',
                  controller: _daftarConfirmPasswordController,
                  obscureText: _daftarConfirmObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _daftarConfirmObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _daftarConfirmObscure = !_daftarConfirmObscure;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _agreementChecked,
                        onChanged: (val) {
                          setState(() {
                            _agreementChecked = val ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Saya mahasiswa kampus ini dan setuju dengan aturan penggunaan.',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppButton(
                  text: 'Daftar',
                  width: double.infinity,
                  height: 44,
                  onPressed: _agreementChecked ? _submitDaftar : null,
                ),
                const SizedBox(height: 14),
                const InfoBanner(
                  message: 'Kami kirim tautan verifikasi ke email kampusmu.',
                  icon: Icons.mark_email_read_outlined,
                  type: InfoBannerType.info,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: const Text(
                          'Masuk di sini',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
