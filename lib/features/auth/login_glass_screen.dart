import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/info_banner.dart';

class LoginGlassScreen extends ConsumerStatefulWidget {
  const LoginGlassScreen({super.key});

  @override
  ConsumerState<LoginGlassScreen> createState() => _LoginGlassScreenState();
}

class _LoginGlassScreenState extends ConsumerState<LoginGlassScreen> {
  final _emailController =
      TextEditingController(text: 'mahasiswa@kampus.ac.id');
  final _passwordController = TextEditingController(text: 'kata sandi');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _emailController.text.trim();
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
              email: email.isEmpty ? '2110511042@mahasiswa.kampus.ac.id' : email,
              role: UserRole.student,
              verificationStatus: VerificationStatus.verified,
              monthlyQuotaUsed: 2,
              monthlyQuotaMax: 5,
            ),
          );
      context.go('/feed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F2F6),
              Color(0xFFD6E7EF),
              Color(0xFFE4F0F6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glassmorphism Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 28),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0E6B85).withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Circular Icon Bubble
                            Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x330E6B85),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'MASUK',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Portal Aspirasi Mahasiswa',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 22),

                            // Field: Email Kampus
                            AppTextField(
                              label: 'EMAIL KAMPUS',
                              hintText: 'mahasiswa@kampus.ac.id',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),

                            // Field: Kata Sandi
                            AppTextField(
                              label: 'KATA SANDI',
                              hintText: 'kata sandi',
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Lupa kata sandi?
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Lupa kata sandi?',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Tombol Masuk
                            AppButton(
                              text: 'MASUK',
                              width: double.infinity,
                              height: 44,
                              onPressed: _onLogin,
                            ),
                            const SizedBox(height: 16),

                            // Belum punya akun? Daftar
                            Row(
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
                                  onTap: () => context.go('/auth/daftar'),
                                  child: const Text(
                                    'Daftar',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Banner Bawah
                  const InfoBanner(
                    message:
                        'Privasi Terjamin: Identitasmu disamarkan dan tidak dipublikasikan.',
                    icon: Icons.shield_outlined,
                    type: InfoBannerType.info,
                  ),

                  // Quick test access helper
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.go('/auth/masuk'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Mode Tab Masuk/Daftar',
                            style: TextStyle(fontSize: 10, color: AppColors.primary)),
                      ),
                      TextButton(
                        onPressed: () => context.go('/auth/verifikasi-ditolak'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('KTM Ditolak',
                            style: TextStyle(fontSize: 10, color: AppColors.dangerRed)),
                      ),
                      TextButton(
                        onPressed: () => context.go('/auth/verifikasi-menunggu'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('KTM Menunggu',
                            style: TextStyle(fontSize: 10, color: AppColors.pendingAmber)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
