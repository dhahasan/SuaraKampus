import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/category_chip.dart';
import 'widgets/admin_header.dart';

class TindakLanjutScreen extends ConsumerStatefulWidget {
  const TindakLanjutScreen({super.key});

  @override
  ConsumerState<TindakLanjutScreen> createState() => _TindakLanjutScreenState();
}

class _TindakLanjutScreenState extends ConsumerState<TindakLanjutScreen> {
  int _selectedTab = 0; // 0: Semua Unit, 1: Biro Sarpras, 2: Bagian Keuangan

  @override
  Widget build(BuildContext context) {
    final allDispositions = ref.watch(dispositionProvider);

    final sarprasCount = allDispositions
        .where((d) => d.unit.toLowerCase().contains('sarpras'))
        .length;
    final keuanganCount = allDispositions
        .where((d) => d.unit.toLowerCase().contains('keuangan'))
        .length;
    final waitingCount = allDispositions
        .where((d) => d.status.toLowerCase().contains('menunggu'))
        .length;
    final resolvedCount = allDispositions
        .where((d) => d.status.toLowerCase().contains('selesai'))
        .length;

    List<Disposition> filteredList;
    if (_selectedTab == 1) {
      filteredList = allDispositions
          .where((d) => d.unit.toLowerCase().contains('sarpras'))
          .toList();
    } else if (_selectedTab == 2) {
      filteredList = allDispositions
          .where((d) => d.unit.toLowerCase().contains('keuangan'))
          .toList();
    } else {
      filteredList = allDispositions;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AdminHeader(),
            const Divider(height: 1, color: AppColors.borderCard),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card: Disposisi & Eskalasi Kampus
                    AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.account_balance_outlined,
                                      size: 16, color: AppColors.primary),
                                  SizedBox(width: 6),
                                  Text(
                                    'Disposisi & Eskalasi Kampus',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F5F8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.borderCard, width: 0.8),
                                ),
                                child: const Text(
                                  'Oktober 2024',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 3 Stats in row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('${allDispositions.length + 6}',
                                  'Diteruskan ke\nUnit', AppColors.textPrimary),
                              Container(
                                  height: 32,
                                  width: 1,
                                  color: AppColors.borderCard),
                              _buildStatItem('${waitingCount + 4}',
                                  'Menunggu\nRespons', AppColors.pendingAmber),
                              Container(
                                  height: 32,
                                  width: 1,
                                  color: AppColors.borderCard),
                              _buildStatItem('${resolvedCount + 42}',
                                  'Selesai\nBulan Ini', AppColors.successGreen),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Bar SLA
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.infoBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.check_circle_outline,
                                    size: 14, color: AppColors.primary),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Target SLA Resolusi Kampus : 85% Tepat Waktu',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Detail',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tabs: Semua Unit, Biro Sarpras, Bagian Keuangan
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(
                            label: 'Semua Unit',
                            count: allDispositions.length,
                            isSelected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Biro Sarpras',
                            count: sarprasCount > 0 ? sarprasCount : null,
                            isSelected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Bagian Keuangan',
                            count: keuanganCount > 0 ? keuanganCount : null,
                            isSelected: _selectedTab == 2,
                            onTap: () => setState(() => _selectedTab = 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Dynamic Disposition Cards from DB
                    if (filteredList.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderCard),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.check_circle_outline,
                                size: 36, color: AppColors.successGreen),
                            SizedBox(height: 8),
                            Text(
                              'Tidak Ada Disposisi',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Semua tiket pada unit ini sudah selesai diproses.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...filteredList.map((d) => _buildDispositionCard(context, d)),

                    // Tindakan Cepat Birokrasi
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Tindakan Cepat Birokrasi',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Icon(Icons.inventory_2_outlined,
                                  size: 15, color: AppColors.textSecondary),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Surat resmi dan pelaporan untuk jajaran Rektorat',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Buat Surat Disposisi',
                                  icon: Icons.description_outlined,
                                  type: AppButtonType.secondary,
                                  height: 38,
                                  fontSize: 10.5,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Draft surat disposisi berhasil dibuat.'),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppButton(
                                  text: 'Ekspor Rekap PDF',
                                  icon: Icons.picture_as_pdf_outlined,
                                  type: AppButtonType.secondary,
                                  height: 38,
                                  fontSize: 10.5,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Rekap PDF disposisi sedang diunduh.'),
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
                    const SizedBox(height: 16),

                    // Footer Sync
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.successGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Sinkronisasi SIPAS Kampus aktif • Realtime Update',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDispositionCard(BuildContext context, Disposition d) {
    final isResolved = d.status == 'Selesai';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3F7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      d.unit.contains('IT')
                          ? Icons.wifi_tethering_rounded
                          : Icons.build_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.unit,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'ID Tiket: ${d.ticketCode}  •  ${d.unitLocation}',
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppBadge(
                text: d.status,
                type: isResolved
                    ? AppBadgeType.success
                    : (d.isOverdue ? AppBadgeType.danger : AppBadgeType.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Estimasi / Overdue alert
          Row(
            children: [
              Icon(
                d.isOverdue
                    ? Icons.warning_amber_rounded
                    : Icons.schedule,
                size: 12,
                color: d.isOverdue ? AppColors.dangerRed : (isResolved ? AppColors.successGreen : AppColors.primaryDark),
              ),
              const SizedBox(width: 4),
              Text(
                d.estimateRemaining,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: d.isOverdue ? AppColors.dangerRed : (isResolved ? AppColors.successGreen : AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Quote Menfess
          Text(
            '"${d.menfessQuote}"',
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          // Correspondence detail
          if (d.correspondenceDetail != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: d.isOverdue ? const Color(0xFFFFF7EA) : const Color(0xFFF9FBFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: d.isOverdue ? const Color(0xFFF9E4BE) : AppColors.borderCard,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history_edu_outlined,
                          size: 12,
                          color: d.isOverdue ? const Color(0xFF946200) : AppColors.primary),
                      const SizedBox(width: 5),
                      Text(
                        'Jejak Disposisi & Korespondensi',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: d.isOverdue ? const Color(0xFF946200) : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    d.correspondenceDetail!,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: d.isOverdue ? const Color(0xFF946200) : AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  if (d.logs.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    ...d.logs.map((log) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '• ${log.time}: ${log.text}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Actions
          if (!isResolved) ...[
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Kirim Pengingat',
                    icon: Icons.notifications_none,
                    type: AppButtonType.secondary,
                    height: 36,
                    fontSize: 11,
                    onPressed: () {
                      ref.read(dispositionProvider.notifier).sendReminder(d.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pengingat dikirim ke ${d.unit}.'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    text: 'Perbarui Status Selesai',
                    icon: Icons.check_circle_outline,
                    type: AppButtonType.primary,
                    height: 36,
                    fontSize: 11,
                    onPressed: () {
                      ref.read(dispositionProvider.notifier).markResolved(d.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tiket ${d.ticketCode} ditandai Selesai.'),
                          backgroundColor: AppColors.successGreen,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (d.isOverdue) ...[
              const SizedBox(height: 8),
              AppButton(
                text: 'Eskalasi ke Pimpinan',
                icon: Icons.trending_up_rounded,
                type: AppButtonType.dangerOutline,
                width: double.infinity,
                height: 34,
                fontSize: 11,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Eskalasi terkirim ke Wakil Rektor Bidang Sarana & IT.'),
                      backgroundColor: AppColors.dangerRed,
                    ),
                  );
                },
              ),
            ],
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle, size: 14, color: AppColors.successGreen),
                  SizedBox(width: 6),
                  Text(
                    'Tiket Telah Selesai Ditangani',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color countColor) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: countColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9.5,
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
