import 'package:flutter/material.dart';
import 'package:momochari/model/cycle_port_model.dart';

class PortDetailView extends StatelessWidget {
  final CyclePort port;

  const PortDetailView({super.key, required this.port});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(port.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('貸出可能台数: ${port.rent}'),
            Text('返却可能台数: ${port.returnNumber}'),
          ],
        ),
      ),
    );
  }
}
