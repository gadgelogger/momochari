import 'package:flutter/material.dart';

class PortDetailView extends StatelessWidget {
  final Map<String, String> port;

  const PortDetailView({super.key, required this.port});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(port['name']!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('貸出可能台数: ${port['rent']}'),
            Text('返却可能台数: ${port['return']}'),
          ],
        ),
      ),
    );
  }
}
