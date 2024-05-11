import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:momochari/main.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: SizedBox(
          width: 300,
          height: 300,
          child: Image.asset('assets/splash.gif'),
        ), // スプラッシュ画像のパス
        nextScreen: MainPage(), // スプラッシュ後に表示するWidget
        splashTransition: SplashTransition.fadeTransition, // スプラッシュ画面の遷移アニメーション
        splashIconSize: 200,
        pageTransitionType: PageTransitionType.rightToLeft, // 表示画面の遷移アニメーション
        backgroundColor: const Color.fromRGBO(244, 156, 200, 1) // 背景色
        );
  }
}
