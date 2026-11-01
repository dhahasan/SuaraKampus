import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 4) return '$name***@$domain';
    return '${name.substring(0, 4)}***${name.substring(name.length - 2)}@$domain';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Profil Mahasiswa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppBadge(text: 'Akun Aktif', type: AppBadgeType.success),
                ],
              ),
              const SizedBox(height: 20),

              // Profile Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mahasiswa Anonim',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _maskEmail(user.email),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AppBadge(
                            text: user.isVerified
                                ? 'KTM Terverifikasi'
                                : 'KTM Belum Valid',
                            type: user.isVerified
                                ? AppBadgeType.success
                                : AppBadgeType.warning,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quota Status Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sisa Kuota Menfess Bulan Ini',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${user.remainingQuota} dari ${user.monthlyQuotaMax}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: user.monthlyQuotaUsed / user.monthlyQuotaMax,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE8F1F5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          user.isQuotaExhausted
                              ? AppColors.dangerRed
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jatah kuota akan otomatis di-reset pada tanggal 1 setiap bulan.',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Role Switch Demo helper (Admin Panel vs Student)
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Beralih Hak Akses (Demo & Evaluasi)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Aplikasi SuaraKampus memiliki 2 peran: Mahasiswa dan Admin Moderasi.',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Buka Panel Admin (Moderasi & Kelola)',
                      icon: Icons.admin_panel_settings_outlined,
                      type: AppButtonType.secondary,
                      width: double.infinity,
                      height: 40,
                      onPressed: () {
                        ref.read(currentUserProvider.notifier).setUser(
                              user.copyWith(role: UserRole.admin),
                            );
                        context.go('/admin/moderasi');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              AppButton(
                text: 'Keluar dari Akun',
                type: AppButtonType.dangerOutline,
                icon: Icons.logout_rounded,
                width: double.infinity,
                height: 44,
                onPressed: () {
                  context.go('/login-glass');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
