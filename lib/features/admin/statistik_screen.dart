import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/progress_bar_row.dart';
import '../../core/widgets/stat_card.dart';
import 'widgets/admin_header.dart';

class StatistikScreen extends ConsumerWidget {
  const StatistikScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final analytics = repo.analytics;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AdminHeader(),
            const Divider(height: 1, color: AppColors.borderCard),

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Ringkasan Analitik
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.show_chart,
                                size: 16, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'Ringkasan Analitik',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.borderCard, width: 1),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Bulan Ini (Oktober)',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down,
                                  size: 14, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(Icons.check_circle,
                            size: 11, color: AppColors.successGreen),
                        SizedBox(width: 4),
                        Text(
                          'Sinkronisasi data otomatis per 15 menit • 10:42 WIB',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Grid 2x2 StatCard
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.45,
                      children: [
                        StatCard(
                          title: 'Total Aspirasi',
                          value: '${analytics.total}',
                          subtitle: '↗ ${analytics.totalTrend}',
                          icon: Icons.all_inbox_rounded,
                          iconColor: AppColors.primary,
                          iconBgColor: AppColors.infoBg,
                        ),
                        StatCard(
                          title: 'Diselesaikan Unit',
                          value: '${analytics.resolvedRate}%',
                          subtitle: analytics.resolvedRateNote,
                          icon: Icons.check_circle_outline,
                          iconColor: AppColors.successGreen,
                          iconBgColor: AppColors.successBg,
                        ),
                        StatCard(
                          title: 'Rata-rata Respon',
                          value: '${analytics.avgResponseDays} Hari',
                          subtitle: analytics.avgResponseNote,
                          icon: Icons.schedule,
                          iconColor: AppColors.primary,
                          iconBgColor: AppColors.infoBg,
                        ),
                        StatCard(
                          title: 'Pelanggaran',
                          value: '${analytics.violations}',
                          subtitle: analytics.violationsNote,
                          icon: Icons.gavel_outlined,
                          iconColor: AppColors.dangerRed,
                          iconBgColor: AppColors.dangerBg,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Tren Penyelesaian Aspirasi (Bar Chart)
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Tren Penyelesaian Aspirasi',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppBadge(
                                text: '4 Minggu',
                                type: AppBadgeType.neutral,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Aduan masuk vs tuntas per minggu (Okt)',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Chart Widget
                          SizedBox(
                            height: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: analytics.weeklyTrend.map((wt) {
                                final inHeight = (wt.incoming / 90) * 90;
                                final resHeight = (wt.resolved / 90) * 90;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Incoming bar (grey-blue)
                                        Container(
                                          width: 12,
                                          height: inHeight,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBACFD8),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        // Resolved bar (teal)
                                        Container(
                                          width: 12,
                                          height: resHeight,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      wt.week,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Legend
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFBACFD8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Masuk',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textSecondary)),
                              const SizedBox(width: 16),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Dituntaskan',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Distribusi Kategori Aduan
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Distribusi Kategori Aduan',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Icon(Icons.pie_chart_outline,
                                  size: 14, color: AppColors.textSecondary),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Berdasarkan klasifikasi otomatis laporan mahasiswa',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ProgressBarRow(
                            label: 'Sarana & Prasarana',
                            countText: '132 aduan (46%)',
                            percentage: 0.46,
                            barColor: AppColors.primary,
                          ),
                          ProgressBarRow(
                            label: 'Akademik & Dosen',
                            countText: '78 aduan (28%)',
                            percentage: 0.28,
                            barColor: const Color(0xFF1E88E5),
                          ),
                          ProgressBarRow(
                            label: 'Keuangan & UKT',
                            countText: '45 aduan (16%)',
                            percentage: 0.16,
                            barColor: const Color(0xFF43A047),
                          ),
                          ProgressBarRow(
                            label: 'Layanan IT & Fasilitas',
                            countText: '29 aduan (10%)',
                            percentage: 0.10,
                            barColor: const Color(0xFFFB8C00),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Performa Unit Kampus
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Performa Unit Kampus',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppBadge(
                                text: 'SLA 48 Jam',
                                type: AppBadgeType.neutral,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Tingkat ketuntasan & tindak lanjut kerja',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Biro Sarpras
                          _buildUnitPerformanceRow(
                            icon: Icons.business,
                            name: 'Biro Sarpras',
                            avgResponse: 'Rata-rata 1.1 hari respon',
                            percentage: '94%',
                            badgeText: 'Kecepatan Baik',
                            badgeType: AppBadgeType.success,
                          ),
                          const Divider(height: 16, color: Color(0xFFEFF5F8)),

                          // Biro Akademik
                          _buildUnitPerformanceRow(
                            icon: Icons.school_outlined,
                            name: 'Biro Akademik',
                            avgResponse: 'Rata-rata 1.8 hari respon',
                            percentage: '82%',
                            badgeText: 'Normal',
                            badgeType: AppBadgeType.primary,
                          ),
                          const Divider(height: 16, color: Color(0xFFEFF5F8)),

                          // Bagian Keuangan
                          _buildUnitPerformanceRow(
                            icon: Icons.receipt_long_outlined,
                            name: 'Bagian Keuangan',
                            avgResponse: 'Rata-rata 3.2 hari respon',
                            percentage: '71%',
                            badgeText: 'Perlu Eskalasi',
                            badgeType: AppBadgeType.danger,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Laporan Eksekutif Bulanan Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFCCE4EE), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.article_outlined,
                                  color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Laporan Eksekutif Bulanan',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Dokumen rekapitulasi komprehensif resmi untuk pelaporan Rektorat, DEMA, dan jajaran BEM Kampus.',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Unduh PDF',
                                  icon: Icons.download_rounded,
                                  type: AppButtonType.primary,
                                  height: 38,
                                  fontSize: 11,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Mengunduh Laporan Eksekutif PDF...'),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppButton(
                                  text: 'Unduh Excel',
                                  icon: Icons.table_chart_outlined,
                                  type: AppButtonType.outline,
                                  height: 38,
                                  fontSize: 11,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Mengunduh Rekapitulasi Excel...'),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitPerformanceRow({
    required IconData icon,
    required String name,
    required String avgResponse,
    required String percentage,
    required String badgeText,
    required AppBadgeType badgeType,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F6F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                avgResponse,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            AppBadge(
              text: badgeText,
              type: badgeType,
              fontSize: 8.5,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            ),
          ],
        ),
      ],
    );
  }
}
