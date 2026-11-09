import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/auth_service.dart';
import '../../core/data/mock_repository.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/info_banner.dart';

class AuthTabScreen extends ConsumerStatefulWidget {
  final int initialTabIndex; // 0: Masuk, 1: Daftar

  const AuthTabScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<AuthTabScreen> createState() => _AuthTabScreenState();
}

class _AuthTabScreenState extends ConsumerState<AuthTabScreen> {
  late int _selectedTab;

  // Masuk controllers
  final _masukEmailController =
      TextEditingController(text: 'mahasiswa@kampus.ac.id');
  final _masukPasswordController = TextEditingController(text: 'kampus123');
  bool _masukObscure = true;
  String? _masukErrorMessage;
  bool _isMasukLoading = false;

  // Daftar controllers
  final _daftarEmailController =
      TextEditingController(text: '2110511042@mahasiswa.kampus.ac.id');
  final _daftarPasswordController = TextEditingController(text: 'password1234');
  final _daftarConfirmPasswordController =
      TextEditingController(text: 'password1234');
  bool _daftarObscure = true;
  bool _daftarConfirmObscure = true;
  bool _agreementChecked = true;
  String? _daftarErrorMessage;
  bool _isDaftarLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _masukEmailController.dispose();
    _masukPasswordController.dispose();
    _daftarEmailController.dispose();
    _daftarPasswordController.dispose();
    _daftarConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitMasuk() async {
    final email = _masukEmailController.text;
    final password = _masukPasswordController.text;

    setState(() {
      _masukErrorMessage = null;
      _isMasukLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final result = AuthService.instance.validateLogin(
      email: email,
      password: password,
    );

    if (!result.isSuccess) {
      setState(() {
        _masukErrorMessage = result.errorMessage;
        _isMasukLoading = false;
      });
      return;
    }

    setState(() => _isMasukLoading = false);

    final user = result.user!;
    ref.read(currentUserProvider.notifier).setUser(user);

    if (user.role == UserRole.admin) {
      context.go('/admin/moderasi');
    } else {
      context.go('/feed');
    }
  }

  Future<void> _submitDaftar() async {
    final email = _daftarEmailController.text;
    final password = _daftarPasswordController.text;
    final confirmPassword = _daftarConfirmPasswordController.text;

    setState(() {
      _daftarErrorMessage = null;
      _isDaftarLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final result = AuthService.instance.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      agreementChecked: _agreementChecked,
    );

    if (!result.isSuccess) {
      setState(() {
        _daftarErrorMessage = result.errorMessage;
        _isDaftarLoading = false;
      });
      return;
    }

    setState(() => _isDaftarLoading = false);

    final user = result.user!;
    ref.read(currentUserProvider.notifier).setUser(user);
    context.go('/auth/verifikasi-menunggu');
  }

  void _showPasswordHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Bantuan Kata Sandi',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Untuk mengatur ulang kata sandi SSO Kampus, hubungi helpdesk IT kampus melalui it-helpdesk@kampus.ac.id atau gunakan akun demo yang telah disediakan.',
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDaftar = _selectedTab == 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Kiri
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.forum_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SuaraKampus',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Portal Aspirasi Mahasiswa',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => context.go('/login-glass'),
                    icon: const Icon(Icons.style_outlined,
                        size: 14, color: AppColors.primary),
                    label: const Text('Tampilan Glass',
                        style: TextStyle(fontSize: 11, color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Segmented Tab 2 Sisi: Masuk | Daftar
              Container(
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F0F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderCard, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 0;
                            _masukErrorMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: !isDaftar ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: !isDaftar
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: !isDaftar
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: !isDaftar
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 1;
                            _daftarErrorMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isDaftar ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isDaftar
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isDaftar
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isDaftar
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Form content
              if (!isDaftar) ...[
                // TAB MASUK (3.4)
                AppTextField(
                  label: 'Email Kampus',
                  hintText: 'mahasiswa@kampus.ac.id',
                  controller: _masukEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Kata Sandi',
                  hintText: '••••••••',
                  controller: _masukPasswordController,
                  obscureText: _masukObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _masukObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _masukObscure = !_masukObscure;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _showPasswordHelpDialog,
                    child: const Text(
                      'Lupa sandi?',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Error message banner on wrong password or email
                if (_masukErrorMessage != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.dangerBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.dangerBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 14, color: AppColors.dangerRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _masukErrorMessage!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.dangerRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                AppButton(
                  text: _isMasukLoading ? 'Memeriksa...' : 'Masuk',
                  width: double.infinity,
                  height: 44,
                  onPressed: _isMasukLoading ? null : _submitMasuk,
                ),
                const SizedBox(height: 18),
                const InfoBanner(
                  message:
                      'Privasi Terjaga: Namamu tidak ditampilkan di publik. Admin hanya melihat email yang kamu daftarkan.',
                  icon: Icons.shield_outlined,
                  type: InfoBannerType.info,
                ),
                const SizedBox(height: 16),

                // Demo accounts quick filler
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Akun Demo (Klik untuk isi cepat):',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          ActionChip(
                            label: const Text('Mahasiswa (kampus123)',
                                style: TextStyle(fontSize: 10)),
                            backgroundColor: AppColors.infoBg,
                            onPressed: () {
                              _masukEmailController.text =
                                  'mahasiswa@kampus.ac.id';
                              _masukPasswordController.text = 'kampus123';
                              setState(() => _masukErrorMessage = null);
                            },
                          ),
                          ActionChip(
                            label: const Text('NIM Mhs (kampus123)',
                                style: TextStyle(fontSize: 10)),
                            backgroundColor: AppColors.infoBg,
                            onPressed: () {
                              _masukEmailController.text =
                                  '2110511042@mahasiswa.kampus.ac.id';
                              _masukPasswordController.text = 'kampus123';
                              setState(() => _masukErrorMessage = null);
                            },
                          ),
                          ActionChip(
                            label: const Text('Admin (admin123)',
                                style: TextStyle(fontSize: 10)),
                            backgroundColor: const Color(0xFFFFF1D6),
                            onPressed: () {
                              _masukEmailController.text =
                                  'admin@kampus.ac.id';
                              _masukPasswordController.text = 'admin123';
                              setState(() => _masukErrorMessage = null);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 1;
                            _daftarErrorMessage = null;
                          });
                        },
                        child: const Text(
                          'Daftar sekarang',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // TAB DAFTAR (3.3)
                AppTextField(
                  label: 'Email/Nomor Kampus',
                  hintText: '2110511042@mahasiswa.kampus.ac.id',
                  controller: _daftarEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gunakan domain email kampus yang valid (mengandung .ac.id)',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Kata Sandi',
                  hintText: 'Minimal 8 karakter',
                  controller: _daftarPasswordController,
                  obscureText: _daftarObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _daftarObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _daftarObscure = !_daftarObscure;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Ulangi Kata Sandi',
                  hintText: 'Ulangi kata sandi di atas',
                  controller: _daftarConfirmPasswordController,
                  obscureText: _daftarConfirmObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _daftarConfirmObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _daftarConfirmObscure = !_daftarConfirmObscure;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _agreementChecked,
                        onChanged: (val) {
                          setState(() {
                            _agreementChecked = val ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Saya mahasiswa kampus ini dan setuju dengan aturan penggunaan.',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),

                // Error message banner on registration error
                if (_daftarErrorMessage != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.dangerBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.dangerBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 14, color: AppColors.dangerRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _daftarErrorMessage!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.dangerRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 18),
                AppButton(
                  text: _isDaftarLoading ? 'Mendaftarkan...' : 'Daftar',
                  width: double.infinity,
                  height: 44,
                  onPressed: _agreementChecked && !_isDaftarLoading
                      ? _submitDaftar
                      : null,
                ),
                const SizedBox(height: 14),
                const InfoBanner(
                  message: 'Kami kirim tautan verifikasi ke email kampusmu.',
                  icon: Icons.mark_email_read_outlined,
                  type: InfoBannerType.info,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 0;
                            _masukErrorMessage = null;
                          });
                        },
                        child: const Text(
                          'Masuk di sini',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
