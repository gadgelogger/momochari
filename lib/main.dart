import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momochari/domain/share_preferences_instance.dart';
import 'package:momochari/domain/theme_mode_provider.dart';
import 'package:momochari/view/info_view.dart';
import 'package:momochari/view/port_list_view.dart';
import 'package:momochari/view/setting_screen.dart';
import 'package:momochari/view/splash_screen.dart';
import 'package:navigator_scope/navigator_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesInstance.initialize();
  runApp(const ProviderScope(child: MainApp()));
}

ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    colorSchemeSeed: const Color.fromRGBO(244, 156, 200, 1),
    useMaterial3: true,
    brightness: brightness,
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ももチャリ',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ref.watch(themeModeProvider),
      home: const SplashScreen(),
    );
  }
}

final baseTabViewProvider = StateProvider<ViewType>((ref) => ViewType.home);

enum ViewType { home, info, setting }

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(baseTabViewProvider);
    return Scaffold(
      body: NavigatorScope(
        currentDestination: viewState.index,
        destinationCount: ViewType.values.length,
        destinationBuilder: (context, index) {
          switch (ViewType.values[index]) {
            case ViewType.home:
              return NestedNavigator(
                builder: (context) => const CyclePortList(),
              );
            case ViewType.info:
              return NestedNavigator(
                builder: (context) => const InfoView(),
              );
            case ViewType.setting:
              return NestedNavigator(
                builder: (context) => const SettingPage(),
              );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewState.index,
        onTap: (int index) {
          ref.read(baseTabViewProvider.notifier).state = ViewType.values[index];
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pedal_bike),
            label: "ポート一覧",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline), label: "お知らせ"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "設定"),
        ],
      ),
    );
  }
}
