import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:momochari/mapview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cycle Port List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapView(),
    );
  }
}

class CyclePortList extends StatefulWidget {
  const CyclePortList({super.key});

  @override
  CyclePortListState createState() => CyclePortListState();
}

class CyclePortListState extends State<CyclePortList> {
  List<Map<String, String>> _cyclePorts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCyclePortData();
  }

  // カンマ区切りのデータをパースしてListに変換する
  List<String> parseCommaSeparated(String value) {
    return value.split(',');
  }

  // HTMLから必要な情報を抽出するための関数
  void fetchCyclePortData() async {
    final response = await http.get(Uri.parse(
        'https://okayama-ccs.jp/dynamic/port/user_portinfo.aspx?WINTYPE=%27SUB%27'));

    // Shift_JISのデコードを試みる
    String responseBody =
        await CharsetConverter.decode('Shift_JIS', response.bodyBytes);

    if (response.statusCode == 200) {
      // HTMLをパースする
      dom.Document document = parser.parse(responseBody);

      // 隠しフィールドから必要なデータを抽出する
      String portNames = document
              .getElementById('ctl00_ContentPlaceHolder1_hdnPortNm')
              ?.attributes['value'] ??
          '';
      String rentNumbers = document
              .getElementById('ctl00_ContentPlaceHolder1_hdnRentNm')
              ?.attributes['value'] ??
          '';
      String returnNumbers = document
              .getElementById('ctl00_ContentPlaceHolder1_hdnRtrnNm')
              ?.attributes['value'] ??
          '';

      List<String> portList = parseCommaSeparated(portNames);
      List<String> rentList = parseCommaSeparated(rentNumbers);
      List<String> returnList = parseCommaSeparated(returnNumbers);

      // ポートの名前、貸し出し可能台数、返却可能台数をまとめる
      List<Map<String, String>> ports = [];
      for (int i = 0; i < portList.length; i++) {
        ports.add({
          'name': portList[i],
          'rent': rentList[i],
          'return': returnList[i],
        });
      }

      setState(() {
        _cyclePorts = ports;
        _loading = false;
      });
    } else {
      // 取得に失敗した場合の処理
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一覧表示'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cyclePorts.length,
              itemBuilder: (context, index) {
                final port = _cyclePorts[index];
                return ListTile(
                  title: Text(port['name'] ?? 'Unknown Port'),
                  subtitle:
                      Text('貸出可能: ${port['rent']}, 返却可能: ${port['return']}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapView()),
          );
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
