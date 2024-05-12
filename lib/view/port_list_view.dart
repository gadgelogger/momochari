import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:momochari/drawer.dart';
import 'package:momochari/model/cycle_port_model.dart';
import 'package:momochari/view/detail_view.dart';
import 'package:momochari/view/mapview.dart';

class CyclePortList extends StatefulWidget {
  const CyclePortList({super.key});

  @override
  CyclePortListState createState() => CyclePortListState();
}

class CyclePortListState extends State<CyclePortList> {
  List<CyclePort> _cyclePorts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCyclePortData();
  }

  @override
  void dispose() {
    _loading = false;
    super.dispose();
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
      String positions = document
              .getElementById('ctl00_ContentPlaceHolder1_hdnAllPos')
              ?.attributes['value'] ??
          '';
      List<String> posList = parseCommaSeparated(positions);
      List<String> portList = parseCommaSeparated(portNames);
      List<String> rentList = parseCommaSeparated(rentNumbers);
      List<String> returnList = parseCommaSeparated(returnNumbers);

      // ポートの名前、貸し出し可能台数、返却可能台数、座標をまとめる
      List<CyclePort> ports = [];
      for (int i = 0; i < portList.length; i++) {
        final pos = posList[i].split(':');

        ports.add(CyclePort(
          name: portList[i],
          rent: rentList[i],
          returnNumber: returnList[i],
          lat: pos[0],
          lng: pos[1],
        ));
      }
      if (mounted) {
        setState(() {
          _cyclePorts = ports;
          _loading = false;
        });
      }
    } else {
      // 取得に失敗した場合の処理
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _goToPortDetail(CyclePort port) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PortDetailView(port: port)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageAssets = List.generate(
      36,
      (index) => 'assets/port_image/${index + 1}.jpg',
    );
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ポート一覧'),
        ),
        drawer: const NavBar(),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  fetchCyclePortData();
                  setState(() {
                    _loading = true;
                  });
                },
                child: ListView.builder(
                  itemCount: _cyclePorts.length,
                  itemBuilder: (context, index) {
                    final port = _cyclePorts[index];
                    final imageIndex = index % imageAssets.length;
                    return ListTile(
                      leading: ClipOval(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            imageAssets[imageIndex],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(port.name),
                      subtitle: Builder(
                        builder: (BuildContext context) {
                          int rent = int.tryParse(port.rent) ?? 0;
                          TextStyle style;
                          if (rent == 0) {
                            style = const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red);
                          } else if (rent <= 5) {
                            style = const TextStyle(color: Colors.orange);
                          } else {
                            style =
                                Theme.of(context).brightness == Brightness.dark
                                    ? const TextStyle(color: Colors.white)
                                    : const TextStyle(color: Colors.black);
                          }
                          return Text(
                              '貸出可能: ${port.rent}, 返却可能: ${port.returnNumber}',
                              style: style);
                        },
                      ),
                      onTap: () => _goToPortDetail(port),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MapView(cyclePorts: _cyclePorts),
              ),
            );
          },
          tooltip: 'Map',
          child: const Icon(Icons.map_outlined),
        ),
      ),
    );
  }
}
