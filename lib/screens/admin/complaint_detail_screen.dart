import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final String complaintId;

  const ComplaintDetailScreen({super.key, required this.complaintId});

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  final List<String> _statusOptions = [
    'pending',
    'In Progress',
    'Resolved',
    'Completed',
  ];

  String? _selectedStatus;
  bool _isSaving = false;

  Future<void> _updateStatus() async {
    if (_selectedStatus == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaintId)
          .update({'status': _selectedStatus});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint status updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to update status: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Resolved':
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Details')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .doc(widget.complaintId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final snapshotData = snapshot.data;
          if (snapshotData == null || !snapshotData.exists) {
            return const Center(child: Text('Complaint not found'));
          }

          final data = snapshotData.data();
          if (data == null) {
            return const Center(child: Text('Complaint data is unavailable'));
          }

          final currentStatus = data['status']?.toString() ?? 'pending';
          _selectedStatus ??= currentStatus;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (data['imageUrl'] != null &&
                    data['imageUrl'].toString().isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      data['imageUrl'],
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  data['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data['description'] ?? 'No description provided.',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    Text('Area: ${data['area'] ?? 'Unknown'}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 18),
                    const SizedBox(width: 6),
                    Text('User ID: ${data['userId'] ?? 'Unknown'}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      data['timestamp'] is Timestamp
                          ? (data['timestamp'] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                          : data['timestamp']?.toString() ?? 'Unknown',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Current Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(currentStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _getStatusColor(currentStatus)),
                  ),
                  child: Text(
                    currentStatus,
                    style: TextStyle(
                      color: _getStatusColor(currentStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Update Status',
                  ),
                  value: _selectedStatus,
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isSaving ? null : _updateStatus,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Status'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
