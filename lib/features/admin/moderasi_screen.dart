import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/info_banner.dart';
import 'widgets/admin_header.dart';

class ModerasiScreen extends ConsumerStatefulWidget {
  const ModerasiScreen({super.key});

  @override
  ConsumerState<ModerasiScreen> createState() => _ModerasiScreenState();
}

class _ModerasiScreenState extends ConsumerState<ModerasiScreen> {
  int _selectedFilterIndex = 0; // 0: Semua, 1: Perlu Sensor, 2: Dilaporkan Civitas

  @override
  Widget build(BuildContext context) {
    final allMenfess = ref.watch(menfessProvider);

    final pendingCount =
        allMenfess.where((m) => m.status == MenfessStatus.pending).length;
    final reportedCount = allMenfess.where((m) => m.reportCount > 0).length;
    final sensitiveCount = allMenfess.where((m) => m.isSensitive).length;

    List<Menfess> displayList;
    if (_selectedFilterIndex == 0) {
      displayList = allMenfess
          .where((m) => m.status == MenfessStatus.pending || m.reportCount > 0)
          .toList();
    } else if (_selectedFilterIndex == 1) {
      displayList = allMenfess.where((m) => m.isSensitive).toList();
    } else {
      displayList = allMenfess.where((m) => m.reportCount > 0).toList();
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
                    // Summary Card: Menunggu Kurasi & Laporan Masuk Urgent
                    AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      'Menunggu Kurasi',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.open_in_new,
                                        size: 11, color: AppColors.textSecondary),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '$pendingCount',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'menfess baru',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 38,
                            width: 1,
                            color: AppColors.borderCard,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Laporan Masuk',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.dangerRed,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'URGENT',
                                        style: TextStyle(
                                          fontSize: 7.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '$reportedCount',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dangerRed,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'perlu telaah',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter Tabs: Semua, Perlu Sensor, Dilaporkan Civitas
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(
                            label: 'Semua',
                            count: pendingCount,
                            isSelected: _selectedFilterIndex == 0,
                            onTap: () => setState(() => _selectedFilterIndex = 0),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Perlu Sensor',
                            count: sensitiveCount > 0 ? sensitiveCount : null,
                            isSelected: _selectedFilterIndex == 1,
                            onTap: () => setState(() => _selectedFilterIndex = 1),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Dilaporkan Civitas',
                            count: reportedCount,
                            isSelected: _selectedFilterIndex == 2,
                            onTap: () => setState(() => _selectedFilterIndex = 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Banner: Mode Tinjau Cepat Aktif
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4F8),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: const Color(0xFFCCE4EE), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flash_on_rounded,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Mode Tinjau Cepat Aktif',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  'Verifikasi masukan berdasarkan parameter standar kampus',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(menfessProvider.notifier)
                                  .approveAllPending();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Semua menfess pending berhasil diloloskan secara serentak.'),
                                  backgroundColor: AppColors.successGreen,
                                ),
                              );
                            },
                            child: const Text(
                              'Loloskan Semua',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Dynamic Menfess Cards from DB
                    if (displayList.isEmpty)
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
                              'Semua Bersih!',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tidak ada menfess yang menunggu peninjauan pada tab ini.',
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
                      ...displayList.map((m) => _buildMenfessCard(context, m)),

                    // Footer with Thumbs-up
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.infoBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tersisa $pendingCount Menfess di Antrean',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Terus jaga ekosistem aspirasi kampus tetap tertib, berimbang, dan solutif.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenfessCard(BuildContext context, Menfess m) {
    final isReported = m.reportCount > 0;

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
                  AppBadge(
                    text: m.category.label,
                    type: AppBadgeType.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${m.code}  ·  ${_formatTimeAgo(m.createdAt)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (isReported)
                AppBadge(
                  text: 'Dilaporkan ${m.reportCount}×',
                  type: AppBadgeType.danger,
                )
              else
                const AppBadge(
                  text: 'Menunggu',
                  type: AppBadgeType.warning,
                  showDot: true,
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Yellow Alasan Pelaporan Banner if reported
          if (isReported && m.reportReasonSummary != null) ...[
            InfoBanner(
              title: 'Alasan Pelaporan Civitas',
              message: '"${m.reportReasonSummary}"',
              icon: Icons.warning_amber_rounded,
              type: InfoBannerType.warning,
            ),
            const SizedBox(height: 8),
          ],

          Text(
            m.body,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),

          // Lampiran Box if exists
          if (m.attachmentUrl != null || m.attachmentName != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderCard, width: 1),
              ),
              child: Row(
                children: [
                  if (m.attachmentUrl != null)
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(m.attachmentUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ada Foto Bukti Terlampir',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          m.attachmentName ?? 'Lampiran_Bukti.jpg',
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Perbesar Gambar ↗',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Actions
          if (isReported) ...[
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Hapus & Sanksi',
                    icon: Icons.delete_outline,
                    type: AppButtonType.danger,
                    height: 38,
                    fontSize: 11.5,
                    onPressed: () {
                      ref.read(menfessProvider.notifier).deleteMenfess(m.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Menfess ${m.code} telah dihapus & pelanggaran dicatat.'),
                          backgroundColor: AppColors.dangerRed,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    text: 'Abaikan Laporan',
                    icon: Icons.check_circle_outline,
                    type: AppButtonType.secondary,
                    height: 38,
                    fontSize: 11.5,
                    onPressed: () {
                      ref.read(menfessProvider.notifier).approveMenfess(m.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Laporan pada ${m.code} diabaikan & aspirasi tetap aktif.'),
                          backgroundColor: AppColors.successGreen,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppButton(
              text: 'Edit & Samarkan Inisial Dosen',
              type: AppButtonType.outline,
              icon: Icons.edit_note_rounded,
              width: double.infinity,
              height: 34,
              fontSize: 11,
              onPressed: () {
                ref.read(menfessProvider.notifier).censorText(m.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Teks ${m.code} berhasil disamarkan menjadi etis.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Loloskan (Publish)',
                    icon: Icons.check,
                    height: 38,
                    fontSize: 11.5,
                    onPressed: () {
                      ref.read(menfessProvider.notifier).approveMenfess(m.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Menfess ${m.code} berhasil diloloskan ke Feed.'),
                          backgroundColor: AppColors.successGreen,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    text: 'Tolak',
                    icon: Icons.close,
                    type: AppButtonType.dangerOutline,
                    height: 38,
                    fontSize: 11.5,
                    onPressed: () {
                      ref.read(menfessProvider.notifier).rejectMenfess(m.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Menfess ${m.code} ditolak.'),
                          backgroundColor: AppColors.dangerRed,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppButton(
              text: 'Sensor Teks Menfess',
              type: AppButtonType.secondary,
              icon: Icons.auto_fix_high_rounded,
              width: double.infinity,
              height: 34,
              fontSize: 11,
              onPressed: () {
                ref.read(menfessProvider.notifier).censorText(m.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Teks ${m.code} berhasil disensor.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes.clamp(1, 60)} mnt lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else {
      return '${diff.inDays} hari lalu';
    }
  }
}
