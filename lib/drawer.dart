import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Text(
              'ももチャリ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('ももチャリって？'),
            onTap: () {
              // Do something
              launchUrlString('https://www.momochari.jp/about/index.html');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('ご利用方法'),
            onTap: () {
              // Do something
              launchUrlString('https://www.momochari.jp/howto/index.html');
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('よくある質問'),
            onTap: () {
              // Do something
              launchUrlString('https://www.momochari.jp/faq/index.html');
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('ヘルメット着用について'),
            onTap: () {
              // Do something
              launchUrlString('https://www.momochari.jp/info/pdf/helmet.pdf');
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('自転車の安全安全について'),
            onTap: () {
              // Do something
              launchUrlString('https://www.pref.okayama.jp/page/343772.html');
            },
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('緊急時の場合\n(運営本部へ電話します)'),
            onTap: () {
              // Do something
              launchUrlString('0120-921-151');
            },
          ),
        ],
      ),
    );
  }
}
