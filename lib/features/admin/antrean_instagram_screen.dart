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

class AntreanInstagramScreen extends ConsumerStatefulWidget {
  const AntreanInstagramScreen({super.key});

  @override
  ConsumerState<AntreanInstagramScreen> createState() =>
      _AntreanInstagramScreenState();
}

class _AntreanInstagramScreenState
    extends ConsumerState<AntreanInstagramScreen> {
  int _selectedTab =
      0; // 0: Antrean Terjadwal, 1: Draft Desain Feed, 2: Sudah Terbit

  @override
  Widget build(BuildContext context) {
    final allPosts = ref.watch(instagramProvider);

    // Filter berdasarkan tab
    final terjadwal =
        allPosts.where((p) => p.status == 'Terjadwal').toList();
    final draft =
        allPosts.where((p) => p.status == 'Draft Desain Feed').toList();
    final terbit =
        allPosts.where((p) => p.status == 'Sudah Terbit').toList();

    final currentList =
        _selectedTab == 0 ? terjadwal : (_selectedTab == 1 ? draft : terbit);

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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          children: [
                            AppBadge(
                              text: 'Slot ${terjadwal.length}/4',
                              type: AppBadgeType.neutral,
                            ),
                            const SizedBox(width: 6),
                            const AppBadge(
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
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
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
                                        children: [
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
                          if (terjadwal.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F7FA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      size: 13, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Jadwal Terdekat: ${terjadwal.first.scheduledTimeText}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  AppBadge(
                                    text: terjadwal.first.scheduleNumber,
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
                            count: terjadwal.length,
                            isSelected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Draf Desain Feed',
                            count: draft.isNotEmpty ? draft.length : null,
                            isSelected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                          const SizedBox(width: 8),
                          CategoryChip(
                            label: 'Sudah Terbit',
                            count: terbit.isNotEmpty ? terbit.length : null,
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

                    // Daftar post dinamis
                    if (currentList.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(Icons.inbox_outlined,
                                  size: 40,
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.4)),
                              const SizedBox(height: 8),
                              Text(
                                _selectedTab == 0
                                    ? 'Belum ada antrean terjadwal'
                                    : _selectedTab == 1
                                        ? 'Belum ada draf desain feed'
                                        : 'Belum ada konten yang terbit',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...currentList.map((post) =>
                          _InstagramPostCard(post: post)),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Button
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

// Widget card per post Instagram
class _InstagramPostCard extends ConsumerWidget {
  final InstagramPost post;

  const _InstagramPostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header baris atas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppBadge(
                    text: '• ${post.status} ${post.scheduleNumber}',
                    type: post.status == 'Terjadwal'
                        ? AppBadgeType.primary
                        : post.status == 'Draft Desain Feed'
                            ? AppBadgeType.neutral
                            : AppBadgeType.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    post.scheduledTimeText,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              AppBadge(
                text: post.format,
                type: AppBadgeType.neutral,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Preview mockup IG
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEAF5F8), Color(0xFFD6ECF3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC8E3ED), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.forum, size: 12, color: AppColors.primary),
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
                      post.facultyTag,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"${post.quoteText}"',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Caption preview
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
          Text(
            post.caption.length > 100
                ? '${post.caption.substring(0, 100)}...'
                : post.caption,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          // Toggle Auto Publish
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FBFD),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.borderCard, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Switch(
                      value: post.autoPublish,
                      onChanged: (val) {
                        ref
                            .read(instagramProvider.notifier)
                            .toggleAutoPublish(post.id);
                      },
                      activeThumbColor: AppColors.primary,
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                    const SizedBox(width: 4),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          size: 16, color: AppColors.textSecondary),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 16, color: AppColors.textSecondary),
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
    );
  }
}
