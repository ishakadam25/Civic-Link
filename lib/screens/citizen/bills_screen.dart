import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  // 🔥 FUNCTIONS
  void openUrl(String link) async {
    final url = Uri.parse(link);

    await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bill Payments")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _buildTile("Electricity Bill", Icons.flash_on, Colors.orange,
              () => openUrl("https://www.tatapower.com/")),

          _buildTile("Water Bill", Icons.water_drop, Colors.blue,
              () => openUrl("https://portal.mcgm.gov.in/")),

          _buildTile("Property Tax", Icons.home, Colors.green,
              () => openUrl("https://ptaxportal.mcgm.gov.in/")),

          _buildTile("Mobile Recharge", Icons.phone_android, Colors.purple,
              () => openUrl("https://paytm.com/recharge")),
        ],
      ),
    );
  }

  Widget _buildTile(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}