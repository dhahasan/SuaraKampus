import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_card.dart';

class RiwayatScreen extends ConsumerWidget {
  const RiwayatScreen({super.key});

  AppBadgeType _getStatusBadgeType(MenfessStatus status) {
    switch (status) {
      case MenfessStatus.pending:
        return AppBadgeType.warning;
      case MenfessStatus.approved:
        return AppBadgeType.primary;
      case MenfessStatus.rejected:
        return AppBadgeType.danger;
      case MenfessStatus.inProgress:
        return AppBadgeType.primary;
      case MenfessStatus.resolved:
        return AppBadgeType.success;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMenfess = ref.watch(menfessProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Riwayat Menfess',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppBadge(
                    text: 'Aspirasi Saya',
                    type: AppBadgeType.neutral,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderCard),

            // List of user's menfess
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allMenfess.length,
                itemBuilder: (context, index) {
                  final item = allMenfess[index];
                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.code} • ${item.category.fullDisplayName}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            AppBadge(
                              text: item.status.label,
                              type: _getStatusBadgeType(item.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.body,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        if (item.status == MenfessStatus.rejected &&
                            item.reportReasonSummary != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.dangerBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline,
                                    size: 13, color: AppColors.dangerRed),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Alasan penolakan: ${item.reportReasonSummary}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.dangerRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dibuat pada ${_formatDate(item.createdAt)}',
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.thumb_up_alt_outlined,
                                    size: 11, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.supportCount} dukungan',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
