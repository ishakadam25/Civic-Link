import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  Future<void> openUrl(String link) async {
    final url = Uri.parse(link);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bill Payments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Pay civic bills quickly',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Quick access to electricity, water, property, and recharge portals.',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildTile(
            context,
            title: 'Electricity',
            icon: Icons.flash_on,
            color: Colors.orange,
            url: 'https://www.tatapower.com/',
          ),
          _buildTile(
            context,
            title: 'Water',
            icon: Icons.water_drop,
            color: Colors.blue,
            url: 'https://portal.mcgm.gov.in/',
          ),
          _buildTile(
            context,
            title: 'Property Tax',
            icon: Icons.home,
            color: Colors.green,
            url: 'https://ptaxportal.mcgm.gov.in/',
          ),
          _buildTile(
            context,
            title: 'Mobile Recharge',
            icon: Icons.phone_android,
            color: Colors.purple,
            url: 'https://paytm.com/recharge',
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => openUrl(url),
      ),
    );
  }
}