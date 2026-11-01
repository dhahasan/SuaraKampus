import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
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
  int _selectedFilterIndex = 0; // 0: Semua (14), 1: Perlu Sensor, 2: Dilaporkan Civitas (3)

  @override
  Widget build(BuildContext context) {
    ref.watch(menfessProvider);

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
                                  children: const [
                                    Text(
                                      '14',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
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
                                  children: const [
                                    Text(
                                      '3',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dangerRed,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
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

                    // Filter Tabs: Semua (14), Perlu Sensor, Dilaporkan Civitas (3)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(
                            label: 'Semua',
                            count: 14,
                            isSelected: _selectedFilterIndex == 0,
                            onTap: () => setState(() => _selectedFilterIndex = 0),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Perlu Sensor',
                            isSelected: _selectedFilterIndex == 1,
                            onTap: () => setState(() => _selectedFilterIndex = 1),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Dilaporkan Civitas',
                            count: 3,
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
                            onTap: () {},
                            child: const Text(
                              'Pilih Semua',
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

                    // Card 1: #MNF-1042 (Sarpras)
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
                                  const AppBadge(
                                    text: 'Sarpras',
                                    type: AppBadgeType.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '#MNF-1042  ·  12 mnt lalu',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const AppBadge(
                                text: 'Menunggu',
                                type: AppBadgeType.warning,
                                showDot: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Kursi di ruang kuliah B203 banyak yang patah dan paku mencuat berbahaya. Tolong pihak sarpras segera cek sebelum ada yang terluka saat perkuliahan berlangsung.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Lampiran Box
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.borderCard, width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(6),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=200',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Ada Foto Bukti Terlampir',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        'Lampiran_B203_Kerusakan.jpg (1.2 MB)',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
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

                          // Actions: [Loloskan (Publish)] [Tolak]
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Loloskan (Publish)',
                                  icon: Icons.check,
                                  height: 38,
                                  fontSize: 11.5,
                                  onPressed: () {
                                    ref
                                        .read(menfessProvider.notifier)
                                        .approveMenfess('m1');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Menfess #MNF-1042 berhasil diloloskan.'),
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
                                    ref
                                        .read(menfessProvider.notifier)
                                        .rejectMenfess('m1');
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
                              ref
                                  .read(menfessProvider.notifier)
                                  .censorText('m1');
                            },
                          ),
                        ],
                      ),
                    ),

                    // Card 2: #MNF-1038 (Dilaporkan Civitas)
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
                                  const AppBadge(
                                    text: 'Akademik',
                                    type: AppBadgeType.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '#MNF-1038  ·  45 mnt lalu',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const AppBadge(
                                text: 'Dilaporkan 3×',
                                type: AppBadgeType.danger,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Yellow Alasan Pelaporan Banner
                          const InfoBanner(
                            title: 'Alasan Pelaporan Civitas',
                            message:
                                '"Menyebut inisial dosen secara spesifik yang berpotensi melanggar pedoman etika digital kampus."',
                            icon: Icons.warning_amber_rounded,
                            type: InfoBannerType.warning,
                          ),
                          const SizedBox(height: 8),

                          const Text(
                            'Dosen mata kuliah Algoritma Pak B** tidak pernah masuk tapi tiba-tiba ngasih tugas deadline 2 jam di tengah malam. Sangat tidak masuk akal untuk kelas reguler.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Small metrics row: 342 dilihat · 28 respon · Melanggar Pasal 4.2
                          Row(
                            children: const [
                              Icon(Icons.remove_red_eye_outlined,
                                  size: 11, color: AppColors.textSecondary),
                              SizedBox(width: 4),
                              Text('342 dilihat',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textSecondary)),
                              SizedBox(width: 10),
                              Icon(Icons.chat_bubble_outline,
                                  size: 11, color: AppColors.textSecondary),
                              SizedBox(width: 4),
                              Text('28 respon',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textSecondary)),
                              SizedBox(width: 10),
                              Icon(Icons.gavel_outlined,
                                  size: 11, color: AppColors.dangerRed),
                              SizedBox(width: 4),
                              Text('Melanggar Pasal 4.2',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.dangerRed,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Actions: [Hapus & Sanksi] [Abaikan Laporan]
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
                                    ref
                                        .read(menfessProvider.notifier)
                                        .deleteMenfess('m2');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Menfess #MNF-1038 dihapus dan disanksi.'),
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
                                  type: AppButtonType.outline,
                                  height: 38,
                                  fontSize: 11.5,
                                  onPressed: () {
                                    ref
                                        .read(menfessProvider.notifier)
                                        .approveMenfess('m2');
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AppButton(
                            text: 'Edit & Samarkan Inisial Dosen',
                            type: AppButtonType.secondary,
                            icon: Icons.edit_note,
                            width: double.infinity,
                            height: 34,
                            fontSize: 11,
                            onPressed: () {
                              ref
                                  .read(menfessProvider.notifier)
                                  .censorText('m2');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Inisial dosen berhasil disamarkan menjadi anonim.'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Card 3: #MNF-1045 (Fasilitas)
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
                                  const AppBadge(
                                    text: 'Fasilitas',
                                    type: AppBadgeType.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '#MNF-1045  ·  1 jam lalu',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const AppBadge(
                                text: 'Menunggu',
                                type: AppBadgeType.warning,
                                showDot: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Kantin Fakultas Teknik tolong disediakan tempat sampah terpisah untuk organik dan anorganik. Saat ini sering meluber pas jam makan siang.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Varian Buttons: [Loloskan Segera] [Tahan Dulu]
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Loloskan Segera',
                                  icon: Icons.check,
                                  height: 38,
                                  fontSize: 11.5,
                                  onPressed: () {
                                    ref
                                        .read(menfessProvider.notifier)
                                        .approveMenfess('m3');
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppButton(
                                  text: 'Tahan Dulu',
                                  type: AppButtonType.outline,
                                  height: 38,
                                  fontSize: 11.5,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

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
                          const Text(
                            'Tersisa 12 Menfess di Antrean',
                            style: TextStyle(
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
}
