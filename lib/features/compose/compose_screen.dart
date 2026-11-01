import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/info_banner.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  MenfessCategory _selectedCategory = MenfessCategory.sarpras;
  final TextEditingController _bodyController = TextEditingController(
    text: 'Kursi di ruang kelas B203 banyak yang patah dan belum diganti.',
  );
  bool _allowInstagram = true;
  final bool _isAnonymous = true;
  XFile? _attachedImage;
  final ImagePicker _picker = ImagePicker();
  bool _simulateQuotaExhausted = false;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  bool _detectSensitiveCivitas(String text) {
    final lower = text.toLowerCase();
    return lower.contains('pak ') ||
        lower.contains('bu ') ||
        lower.contains('dosen ') ||
        lower.contains('prof.') ||
        lower.contains('dr.');
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _attachedImage = image;
      });
    }
  }

  void _submit() {
    final text = _bodyController.text.trim();
    if (text.isEmpty) return;

    ref.read(menfessProvider.notifier).addMenfess(
          category: _selectedCategory,
          body: text,
          attachmentName: _attachedImage != null ? 'Lampiran_Bukti.jpg' : null,
          allowInstagram: _allowInstagram,
          isAnonymous: _isAnonymous,
        );

    ref.read(currentUserProvider.notifier).useQuota();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menfess berhasil dikirim dan menunggu moderasi admin.'),
        backgroundColor: AppColors.primary,
      ),
    );

    context.go('/feed');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isQuotaHabis = _simulateQuotaExhausted || user.isQuotaExhausted;
    final currentText = _bodyController.text;
    final isSensitive = _detectSensitiveCivitas(currentText);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.campaign_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tulis Aduan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go('/profil'),
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
            ),
            const Divider(height: 1, color: AppColors.borderCard),

            // Demo Variant Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: const Color(0xFFEFF5F8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Simulasi Kuota: ',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  InkWell(
                    onTap: () => setState(() => _simulateQuotaExhausted = false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        'Normal (Sisa 3 dari 5)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: !_simulateQuotaExhausted ? FontWeight.bold : FontWeight.normal,
                          color: !_simulateQuotaExhausted ? AppColors.successGreen : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const Text(' • ', style: TextStyle(color: AppColors.textSecondary)),
                  InkWell(
                    onTap: () => setState(() => _simulateQuotaExhausted = true),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        'Kuota Habis (0/5)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: _simulateQuotaExhausted ? FontWeight.bold : FontWeight.normal,
                          color: _simulateQuotaExhausted ? AppColors.dangerRed : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Sub
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tulis Menfess',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isQuotaHabis
                                  ? 'Sampaikan aspirasi anonim secara santun'
                                  : 'Sisa 3 dari 5 kuota bulan ini',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: isQuotaHabis
                                    ? AppColors.textSecondary
                                    : AppColors.primary,
                                fontWeight: isQuotaHabis
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (isQuotaHabis)
                          const AppBadge(
                            text: '0 dari 5 tersisa',
                            type: AppBadgeType.danger,
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.successBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.successBorder,
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              '✓ Verifikasi 3 dari 5 kuota bulan ini',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.successGreen,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // VARIAN 1: KUOTA BULAN INI HABIS
                    if (isQuotaHabis) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.dangerBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.dangerBorder, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.lock_clock,
                                      color: AppColors.dangerRed,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Kuota Bulan Ini Habis',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dangerRed,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Bulan Berjalan',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dangerRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Kamu telah menggunakan seluruh jatah 5 menfess bulan ini. Kuota diperbarui otomatis setiap tanggal 1 pukul 00:00 WIB.',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.dangerRed,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(
                                value: 1.0,
                                minHeight: 6,
                                backgroundColor: Color(0xFFF6C8C8),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.dangerRed),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              children: [
                                Icon(Icons.timer_outlined,
                                    size: 11, color: AppColors.dangerRed),
                                SizedBox(width: 4),
                                Text(
                                  'Reset dalam 9 hari',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.dangerRed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Section Kategori
                    Text(
                      isQuotaHabis ? 'Kategori Aspirasi' : 'Pilih Kategori',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MenfessCategory.akademik,
                          MenfessCategory.sarpras,
                          MenfessCategory.keuangan,
                          MenfessCategory.layananIt,
                        ].map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CategoryChip(
                              label: cat.label,
                              isSelected: isSelected,
                              isEnabled: !isQuotaHabis,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Keluhan atau Aspirasi / Pesan Menfess
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isQuotaHabis ? 'Pesan Menfess' : 'Keluhan atau Aspirasi',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${currentText.length}/500',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Text Area
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: isQuotaHabis
                            ? const Color(0xFFF4F7F9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColors.borderCard, width: 1),
                      ),
                      child: TextField(
                        controller: _bodyController,
                        enabled: !isQuotaHabis,
                        maxLines: null,
                        maxLength: 500,
                        onChanged: (val) => setState(() {}),
                        style: TextStyle(
                          fontSize: 12,
                          color: isQuotaHabis
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.all(12),
                          border: InputBorder.none,
                          hintText: isQuotaHabis
                              ? 'Kotak input terkunci sementara karena kuota kirim bulan ini telah mencapai batas.'
                              : 'Tuliskan keluhan atau aspirasimu di sini...',
                          hintStyle: TextStyle(
                            fontSize: 11.5,
                            color: isQuotaHabis
                                ? AppColors.textMuted
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Small Identity Protected Notice
                    Row(
                      children: const [
                        Icon(Icons.shield_outlined,
                            size: 11, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          'Identitasmu terenkripsi 100%',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Lampiran Bukti (Opsional)
                    const Text(
                      'Lampiran Bukti (Opsional)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: isQuotaHabis ? null : _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: isQuotaHabis
                              ? const Color(0xFFF4F7F9)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFCCE0EB),
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 24,
                                color: isQuotaHabis
                                    ? AppColors.textMuted
                                    : AppColors.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _attachedImage != null
                                    ? 'Foto Bukti Dipilih ✓'
                                    : 'Tambah foto bukti (opsional)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isQuotaHabis
                                      ? AppColors.textMuted
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'JPG atau PNG maks 5MB',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Yellow Warning Banner: Hindari menyebut nama dosen/civitas
                    if (isSensitive || !isQuotaHabis)
                      const InfoBanner(
                        message:
                            'Hindari menyebut nama dosen, staf, atau ciri yang bisa mengidentifikasi.',
                        icon: Icons.warning_amber_rounded,
                        type: InfoBannerType.warning,
                      ),

                    const SizedBox(height: 8),

                    // Checkbox or Switch options
                    if (isQuotaHabis) ...[
                      // Toggle Posting sebagai Anonim
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Posting sebagai Anonim',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Switch(
                            value: _isAnonymous,
                            onChanged: null, // disabled
                            activeThumbColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ] else ...[
                      // Checkbox Instagram
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: _allowInstagram,
                              onChanged: (val) {
                                setState(() {
                                  _allowInstagram = val ?? true;
                                });
                              },
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Boleh ditampilkan di Instagram @suarakampus_official',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Akan dikurasi admin secara berkala tanpa nama pengirim.',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
                  text: 'Kirim menfess',
                  icon: Icons.send_rounded,
                  width: double.infinity,
                  height: 44,
                  onPressed: isQuotaHabis ? null : _submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
