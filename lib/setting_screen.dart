// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momochari/theme_mode_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
// Project imports:

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final packageInfo = snapshot.data;
          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text("テーマ"),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: const Text("テーマモード"),
                    leading: const Icon(Icons.color_lens),
                    trailing: Text(
                      ref.watch(themeModeProvider).toString(),
                    ),
                    onPressed: (_) async {
                      await ref.read(themeModeProvider.notifier).toggle();
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text("情報"),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.share),
                    title: const Text("このアプリをシェアする"),
                    onPressed: (_) async {
                      final url = Platform.isIOS
                          ? 'https://apps.apple.com/jp/app/ここらへん/id0000000000'
                          : 'https://play.google.com/store/apps/details?id=com.example.kokorahen';
                      await Share.share(url);
                    },
                  ),
                  SettingsTile.navigation(
                    title: const Text("利用規約について"),
                    leading: const Icon(Icons.privacy_tip),
                    onPressed: (BuildContext context) {
                      launchUrlString('https://gadgelogger.com/kokorahenn/');
                    },
                  ),
                  SettingsTile.navigation(
                    title: const Text("お問い合わせ"),
                    leading: const Icon(Icons.info),
                    onPressed: (BuildContext context) {
                      launchUrlString('https://x.com/gadgelogger?s=21');
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text("アプリについて"),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: const Text("ライセンス情報"),
                    leading: const Icon(Icons.terminal),
                    onPressed: (_) => showLicensePage(
                      context: context,
                      applicationName: packageInfo?.appName ?? "",
                      applicationVersion: packageInfo?.version ?? "",
                    ),
                  ),
                  SettingsTile(
                    title: const Text("バージョン"),
                    leading: const Icon(Icons.info_outline),
                    value: Text(packageInfo?.version ?? "test"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
