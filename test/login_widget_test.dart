import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suara_kampus/core/widgets/app_button.dart';
import 'package:suara_kampus/features/auth/auth_tab_screen.dart';
import 'package:suara_kampus/features/auth/login_glass_screen.dart';

void main() {
  group('Login UI Widget Tests', () {
    testWidgets('AuthTabScreen menampilkan error saat kata sandi salah',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthTabScreen(initialTabIndex: 0),
          ),
        ),
      );

      final passwordFields = find.byType(TextField);
      expect(passwordFields, findsNWidgets(2)); // Email & Password

      // Masukkan kata sandi yang salah
      await tester.enterText(passwordFields.at(1), 'sandi_salah_123');
      await tester.pump();

      // Klik tombol Masuk
      final masukButton = find.widgetWithText(AppButton, 'Masuk');
      expect(masukButton, findsOneWidget);
      await tester.tap(masukButton);

      // Tunggu delay simulasi network (300ms)
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Verifikasi bahwa pesan error muncul di UI
      expect(find.text('Kata sandi salah. Silakan coba lagi.'), findsOneWidget);
    });

    testWidgets('LoginGlassScreen menampilkan error saat kata sandi salah',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginGlassScreen(),
          ),
        ),
      );

      final passwordFields = find.byType(TextField);
      expect(passwordFields, findsNWidgets(2));

      await tester.enterText(passwordFields.at(1), 'wrong_password');
      await tester.pump();

      final masukButton = find.widgetWithText(AppButton, 'MASUK');
      expect(masukButton, findsOneWidget);
      await tester.tap(masukButton);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('Kata sandi salah. Silakan coba lagi.'), findsOneWidget);
    });
  });
}
