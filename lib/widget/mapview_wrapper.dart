import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momochari/main.dart';
import 'package:momochari/model/cycle_port_model.dart';
import 'package:momochari/view/mapview.dart';

class MapViewWrapper extends StatelessWidget {
  final List<CyclePort> cyclePorts;

  const MapViewWrapper({super.key, required this.cyclePorts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポートマップ'),
      ),
      body: MapView(cyclePorts: cyclePorts),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'List',
        child: const Icon(Icons.list),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final viewState = ref.watch(baseTabViewProvider);
          return BottomNavigationBar(
            currentIndex: viewState.index,
            onTap: (int index) {
              ref.read(baseTabViewProvider.notifier).state =
                  ViewType.values[index];
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
          );
        },
      ),
    );
  }
}
