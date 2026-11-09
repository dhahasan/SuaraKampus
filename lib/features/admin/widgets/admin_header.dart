import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/mock_repository.dart';
import '../../../core/models/app_models.dart';

class AdminHeader extends ConsumerWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Admin SuaraKampus',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Panel Moderasi & Pengelolaan',
                style: TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: AppColors.textPrimary, size: 20),
                onPressed: () {
                  // Switch to student view or settings
                  ref.read(currentUserProvider.notifier).setUser(
                        const AppUser(
                          id: 'user_1',
                          email: '2110511042@mahasiswa.kampus.ac.id',
                          role: UserRole.student,
                          verificationStatus: VerificationStatus.verified,
                        ),
                      );
                  context.go('/feed');
                },
                tooltip: 'Ganti ke Tampilan Mahasiswa',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 14),
              PopupMenuButton<String>(
                tooltip: 'Menu Admin',
                onSelected: (value) {
                  if (value == 'switch') {
                    ref.read(currentUserProvider.notifier).setUser(
                          const AppUser(
                            id: 'user_1',
                            email: '2110511042@mahasiswa.kampus.ac.id',
                            role: UserRole.student,
                            verificationStatus: VerificationStatus.verified,
                          ),
                        );
                    context.go('/feed');
                  } else if (value == 'logout') {
                    ref.read(currentUserProvider.notifier).logout();
                    context.go('/login-glass');
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'switch',
                    child: Row(
                      children: [
                        Icon(Icons.swap_horiz, size: 16),
                        SizedBox(width: 8),
                        Text('Tampilan Mahasiswa',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 16, color: AppColors.dangerRed),
                        SizedBox(width: 8),
                        Text('Keluar Akun',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.dangerRed)),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
