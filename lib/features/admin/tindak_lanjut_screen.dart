import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
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
  int _selectedTab = 0; // 0: Semua Unit, 1: Biro Sarpras (4), 2: Bagian Keuangan (2)

  @override
  Widget build(BuildContext context) {
    ref.watch(dispositionProvider);

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
                              _buildStatItem('8', 'Diteruskan ke\nUnit',
                                  AppColors.textPrimary),
                              Container(
                                  height: 32,
                                  width: 1,
                                  color: AppColors.borderCard),
                              _buildStatItem('5', 'Menunggu\nRespons',
                                  AppColors.pendingAmber),
                              Container(
                                  height: 32,
                                  width: 1,
                                  color: AppColors.borderCard),
                              _buildStatItem('42', 'Selesai\nBulan Ini',
                                  AppColors.successGreen),
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

                    // Tabs: Semua Unit, Biro Sarpras (4), Bagian Keuangan (2)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(
                            label: 'Semua Unit',
                            isSelected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Biro Sarpras',
                            count: 4,
                            isSelected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Bagian Keuangan',
                            count: 2,
                            isSelected: _selectedTab == 2,
                            onTap: () => setState(() => _selectedTab = 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Unit Card 1: Biro Sarana & Prasarana
                    AppCard(
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
                                    child: const Icon(Icons.build_outlined,
                                        size: 14, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Biro Sarana & Prasarana',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'ID Tiket: #SK-8821  •  Gedung 3',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const AppBadge(
                                text: 'Diproses',
                                type: AppBadgeType.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Estimasi respons tersisa: 2 hari kerja
                          Row(
                            children: const [
                              Icon(Icons.schedule,
                                  size: 12, color: AppColors.dangerRed),
                              SizedBox(width: 4),
                              Text(
                                'Estimasi respons tersisa: 2 hari kerja',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.dangerRed,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Quote Menfess
                          Text(
                            '"AC lab komputer gedung 3 bocor dan air merembes ke kabel stopkontak."',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Jejak Disposisi & Korespondensi Box
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FBFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.borderCard, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Icon(Icons.history_edu_outlined,
                                        size: 12, color: AppColors.primary),
                                    SizedBox(width: 5),
                                    Text(
                                      'Jejak Disposisi & Korespondensi',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Terkirim ke email kabag_sarpras@kampus.ac.id pada 24 Okt. Menunggu konfirmasi pengerjaan fisik di lapangan.',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Actions: [Kirim Pengingat] [Perbarui Status Selesai]
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
                                    ref
                                        .read(dispositionProvider.notifier)
                                        .sendReminder('d1');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Pengingat berhasil dikirimkan ke Biro Sarpras.'),
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
                                    ref
                                        .read(dispositionProvider.notifier)
                                        .markResolved('d1');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Tiket #SK-8821 ditandai Selesai.'),
                                        backgroundColor: AppColors.successGreen,
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

                    // Unit Card 2: Layanan IT & Jaringan (Overdue)
                    AppCard(
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
                                    child: const Icon(Icons.router_outlined,
                                        size: 14, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Layanan IT & Jaringan',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'ID Tiket: #SK-8819  •  Perpustakaan Lt. 2',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const AppBadge(
                                text: 'Menunggu Respon',
                                type: AppBadgeType.warning,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Alert merah: Telah melebihi 24 jam belum dibaca
                          Row(
                            children: const [
                              Icon(Icons.warning_amber_rounded,
                                  size: 13, color: AppColors.dangerRed),
                              SizedBox(width: 4),
                              Text(
                                '! Telah melebihi 24 jam belum dibaca',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dangerRed,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Quote Menfess
                          Text(
                            '"Koneksi Wi-Fi Eduroam di perpustakaan lantai 2 tidak bisa autentikasi sejak Senin."',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Auto webhook note
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7EA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFFF9E4BE), width: 1),
                            ),
                            child: const Text(
                              'Tiket terdistribusi otomatis via webhook kampus. Unit IT belum menetapkan PIC penanganan jaringan.',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF946200),
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Actions: [Eskalasi ke Pimpinan] [Catatan Internal]
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Eskalasi ke Pimpinan',
                                  icon: Icons.trending_up_rounded,
                                  type: AppButtonType.dangerOutline,
                                  height: 36,
                                  fontSize: 11,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Eskalasi terkirim ke Wakil Rektor Bidang Sarana & IT.'),
                                        backgroundColor: AppColors.dangerRed,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppButton(
                                  text: 'Catatan Internal',
                                  icon: Icons.note_add_outlined,
                                  type: AppButtonType.secondary,
                                  height: 36,
                                  fontSize: 11,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

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
                                  onPressed: () {},
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
                                  onPressed: () {},
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
