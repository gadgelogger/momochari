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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              port.imageAsset,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    port.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('貸出可能台数: ${port.rent}'),
                  const SizedBox(height: 8),
                  Text('返却可能台数: ${port.returnNumber}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
