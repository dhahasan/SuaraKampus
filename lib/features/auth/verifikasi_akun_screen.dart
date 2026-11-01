import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/info_banner.dart';

class VerifikasiAkunScreen extends ConsumerStatefulWidget {
  final bool isRejectedInitial;

  const VerifikasiAkunScreen({
    super.key,
    this.isRejectedInitial = false,
  });

  @override
  ConsumerState<VerifikasiAkunScreen> createState() =>
      _VerifikasiAkunScreenState();
}

class _VerifikasiAkunScreenState extends ConsumerState<VerifikasiAkunScreen> {
  late bool _isRejected;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isRejected = widget.isRejectedInitial;
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submit() {
    // Set to pending or verified and proceed to Feed
    ref.read(currentUserProvider.notifier).setVerification(
          VerificationStatus.verified,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto KTM berhasil dikirimkan ke tim verifikasi.'),
        backgroundColor: AppColors.successGreen,
      ),
    );
    context.go('/feed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Verifikasi Akun',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Langkah pengaktifan akun mahasiswa',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  AppBadge(
                    text: _isRejected ? 'Ditolak' : 'Menunggu',
                    type: _isRejected
                        ? AppBadgeType.danger
                        : AppBadgeType.warning,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderCard),

            // Mode switch helper for demo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: const Color(0xFFF1F6F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat Varian: ',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _isRejected = true),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        'Varian Ditolak',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: _isRejected ? FontWeight.bold : FontWeight.normal,
                          color: _isRejected ? AppColors.dangerRed : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const Text(' • ', style: TextStyle(color: AppColors.textSecondary)),
                  InkWell(
                    onTap: () => setState(() => _isRejected = false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        'Varian Menunggu',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: !_isRejected ? FontWeight.bold : FontWeight.normal,
                          color: !_isRejected ? AppColors.pendingAmber : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Red alert card if rejected
                    if (_isRejected) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dangerBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.dangerBorder,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.cancel_outlined,
                              color: AppColors.dangerRed,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verifikasi Belum Berhasil',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dangerRed,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Foto KTM buram. Unggah ulang dengan pencahayaan lebih terang.',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: AppColors.dangerRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Vertical Stepper
                    // Step 1: Email Terverifikasi
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.successGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Email terverifikasi',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '2110511042@mahasiswa.kampus.ac.id',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Connecting vertical line
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 2,
                      height: 20,
                      color: AppColors.borderCard,
                    ),

                    // Step 2: Unggah Foto KTM
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _isRejected
                                ? AppColors.dangerRed
                                : AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: _isRejected
                                ? const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : const Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isRejected
                                    ? 'Unggah Foto KTM (Perlu Revisi)'
                                    : 'Unggah Foto KTM',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _isRejected
                                      ? AppColors.dangerRed
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isRejected
                                    ? 'Mohon ambil ulang foto kartu tanda mahasiswa'
                                    : 'Langkah akhir untuk validasi civitas',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Kotak dashed upload foto KTM
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _isRejected
                                ? AppColors.dangerBorder
                                : const Color(0xFFB8D5E5),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _selectedImage != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Ganti Foto',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.infoBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _isRejected
                                        ? 'Ketuk untuk mengunggah foto KTM baru'
                                        : 'Ketuk untuk mengunggah foto KTM',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _isRejected
                                        ? 'Gunakan tempat dengan pencahayaan terang dan teks terbaca'
                                        : 'Pastikan foto jelas, tidak buram atau terpotong',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info Card: Kebijakan Keamanan KTM
                    const InfoBanner(
                      title: 'Kebijakan Keamanan KTM',
                      message:
                          'KTM hanya dilihat admin untuk verifikasi dan dihapus setelah selesai. Identitasmu tidak menampilkan namamu di publik, tetapi admin dapat melihat email yang kamu daftarkan.',
                      icon: Icons.lock_outline,
                      type: InfoBannerType.info,
                    ),
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
                  text: _isRejected ? 'Unggah ulang' : 'Kirim KTM',
                  width: double.infinity,
                  height: 44,
                  onPressed: _submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
