import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/info_banner.dart';
import 'widgets/admin_header.dart';

class AntreanInstagramScreen extends ConsumerStatefulWidget {
  const AntreanInstagramScreen({super.key});

  @override
  ConsumerState<AntreanInstagramScreen> createState() =>
      _AntreanInstagramScreenState();
}

class _AntreanInstagramScreenState extends ConsumerState<AntreanInstagramScreen> {
  int _selectedTab = 0; // 0: Antrean Terjadwal (6), 1: Draft Desain Feed, 2: Sudah Terbit
  bool _autoPublish84 = true;

  @override
  Widget build(BuildContext context) {
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
                    // Title & Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.auto_awesome,
                                    size: 13, color: AppColors.primary),
                                SizedBox(width: 4),
                                Text(
                                  'SOCIAL AUTOMATION',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Antrean Instagram',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            AppBadge(
                              text: 'Slot Harian 3/4',
                              type: AppBadgeType.neutral,
                            ),
                            SizedBox(width: 6),
                            AppBadge(
                              text: 'Template V2',
                              type: AppBadgeType.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Account Status Card
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: AppColors.infoBg,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.primary, width: 1.2),
                                    ),
                                    child: const Icon(Icons.camera_alt_outlined,
                                        size: 18, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            '@suarakampus_official',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.verified,
                                              size: 13,
                                              color: AppColors.primary),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Icon(Icons.check_circle,
                                              size: 10,
                                              color: AppColors.successGreen),
                                          SizedBox(width: 3),
                                          Text(
                                            'Terkoneksi Otomatis',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              color: AppColors.successGreen,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh,
                                    size: 18, color: AppColors.textSecondary),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Upcoming Slot Info
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F7FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.schedule,
                                    size: 13, color: AppColors.primary),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Jadwal Unggahan Terdekat:\nHari ini, 19:00 WIB (Slot Sore)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textPrimary,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                AppBadge(
                                  text: '32 mnt lagi',
                                  type: AppBadgeType.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(
                            label: 'Antrean Terjadwal',
                            count: 6,
                            isSelected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Draf Desain Feed',
                            isSelected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Sudah Terbit',
                            isSelected: _selectedTab == 2,
                            onTap: () => setState(() => _selectedTab = 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Info Banner
                    const InfoBanner(
                      message:
                          'Hanya aspirasi berstatus Disetujui dengan opsi "Boleh tampil di IG" yang masuk kurasi antrean feed.',
                      icon: Icons.info_outline,
                      type: InfoBannerType.info,
                    ),
                    const SizedBox(height: 12),

                    // Card Terjadwal #83 with Instagram Slide Preview
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  AppBadge(
                                    text: '• Terjadwal #83',
                                    type: AppBadgeType.primary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '19:00 WIB',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              AppBadge(
                                text: 'Carousel (3/3)',
                                type: AppBadgeType.neutral,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Instagram Graphic Slide Mockup
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEAF5F8), Color(0xFFD6ECF3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xFFC8E3ED), width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Row(
                                      children: [
                                        Icon(Icons.forum,
                                            size: 12, color: AppColors.primary),
                                        SizedBox(width: 4),
                                        Text(
                                          'SuaraKampus Menfess',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Slide 1',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Text(
                                      '#ASPIRASIKAMPUS',
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Fakultas Ekonomi',
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Evaluasi Mata Kuliah:\n"Alur pembayaran UKT via teller bank mitra sangat membingungkan, tolong.."',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: const [
                                    Text(
                                      'ID: #MNF-9921 • Anonim',
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.chat_bubble_outline,
                                        size: 10,
                                        color: AppColors.textSecondary),
                                    SizedBox(width: 3),
                                    Text(
                                      '142 Respons',
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Caption Preview with Edit
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.short_text,
                                      size: 13, color: AppColors.textSecondary),
                                  SizedBox(width: 4),
                                  Text(
                                    'Caption Pratinjau',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Sobat Kampus, ada masukan penting seputar alur teller UKT semester ini. Mari...\n#SuaraKampus #AspirasiMahasiswa #UKTKampus #Advokasi',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Actions: [Pratinjau Feed] [Ganti Desain]
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Pratinjau Feed',
                                  icon: Icons.remove_red_eye_outlined,
                                  type: AppButtonType.secondary,
                                  height: 36,
                                  fontSize: 11,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppButton(
                                  text: 'Ganti Desain',
                                  icon: Icons.palette_outlined,
                                  type: AppButtonType.outline,
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

                    // Card Terjadwal #84 with toggle Auto-Post
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Row(
                                children: [
                                  AppBadge(
                                    text: '• Terjadwal #84',
                                    type: AppBadgeType.primary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Besok, 12:00 WIB',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Sarana\nPrasarana',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.infoBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.wifi,
                                    size: 14, color: AppColors.primary),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Wi-Fi Gedung C Drop  #HF-8924',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '"Wi-Fi gedung C sering putus saat praktikum daring lab lantai 3. Mohon..."',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '✓ Disetujui Tim Sarpras',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: AppColors.successGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Toggle Publikasikan Otomatis
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FBFD),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.borderCard, width: 0.8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Switch(
                                      value: _autoPublish84,
                                      onChanged: (val) {
                                        setState(() {
                                          _autoPublish84 = val;
                                        });
                                      },
                                      activeThumbColor: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Publikasikan Otomatis',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Auto-post saat jam tiba',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 16,
                                          color: AppColors.textSecondary),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 16,
                                          color: AppColors.textSecondary),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Item Terjadwal #85: Jadwal Bus Kampus Malam
                    AppCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F3F7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '20:30\nBESOK',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Jadwal Bus Kampus Malam  #85',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Format Single Post • Siap Antre',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppButton(
                            text: 'Detail',
                            type: AppButtonType.secondary,
                            height: 28,
                            fontSize: 10,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Button: Generate Feed Batch Hari Ini
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.borderCard, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: AppButton(
                  text: 'Generate Feed Batch Hari Ini',
                  icon: Icons.auto_awesome,
                  width: double.infinity,
                  height: 44,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Batch feed berhasil digenerate dan dijadwalkan ke Instagram.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
