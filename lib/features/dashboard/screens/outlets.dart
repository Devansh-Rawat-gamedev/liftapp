// outlets.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu.dart';

class OutletsScreen extends StatelessWidget {
  final String campusName;
  final String? collegeId;
  final String? campusId;
  final Map<String, dynamic>? campusData;

  const OutletsScreen({
    super.key,
    required this.campusName,
    this.collegeId,
    this.campusId,
    this.campusData,
  });

  @override
  Widget build(BuildContext context) {
    // If campusData is provided (array in college doc)
    if (campusData != null) {
      final rawOutlets = (campusData!['outlets'] as List<dynamic>?) ?? [];
      return Scaffold(
        appBar: AppBar(title: Text('$campusName Outlets')),
        body: rawOutlets.isEmpty
            ? const Center(child: Text('No outlets available'))
            : ListView.builder(
          itemCount: rawOutlets.length,
          itemBuilder: (context, index) {
            final outlet =
                (rawOutlets[index] as Map?)?.cast<String, dynamic>() ??
                    <String, dynamic>{};

            return ListTile(
              leading: const Icon(Icons.store),
              title: Text(outlet['name']?.toString() ?? 'Unnamed Outlet'),
              subtitle:
              Text(outlet['category']?.toString() ?? 'No category'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Pass the inline menu directly to MenuScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MenuScreen.inlineMenu(
                      outletName: outlet['name'] ?? '',
                      menu: (outlet['menu'] as List<dynamic>?) ?? [],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    // Otherwise fetch subcollection from Firestore
    if (collegeId == null || campusId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(campusName)),
        body: const Center(child: Text('Missing campus identifier')),
      );
    }

    final outletsRef = FirebaseFirestore.instance
        .collection('colleges')
        .doc(collegeId)
        .collection('campuses')
        .doc(campusId)
        .collection('outlets');

    return Scaffold(
      appBar: AppBar(title: Text('$campusName Outlets')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: outletsRef.snapshots(),
        builder: (context, outletSnapshot) {
          if (outletSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = outletSnapshot.data?.docs;
          if (docs == null || docs.isEmpty) {
            return const Center(child: Text('No outlets available'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final outletData = doc.data();

              return ListTile(
                leading: const Icon(Icons.store),
                title: Text(outletData?['name']?.toString() ?? 'Unnamed Outlet'),
                subtitle:
                Text(outletData?['category']?.toString() ?? 'No category'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuScreen(
                        collegeId: collegeId!,
                        campusId: campusId!,
                        outletId: doc.id,
                        outletName: outletData?['name'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
