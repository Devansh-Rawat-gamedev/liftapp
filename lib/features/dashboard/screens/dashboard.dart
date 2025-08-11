// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'outlets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collegesRef = FirebaseFirestore.instance.collection('colleges');

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: collegesRef.snapshots(),
        builder: (context, collegeSnapshot) {
          if (collegeSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final collegeDocs = collegeSnapshot.data?.docs;
          if (collegeDocs == null || collegeDocs.isEmpty) {
            return const Center(child: Text('No colleges available'));
          }

          return ListView.builder(
            itemCount: collegeDocs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot<Map<String, dynamic>> college = collegeDocs[index];
              final collegeName = (college.data()?['name'] as String?) ?? 'Unnamed College';

              return ExpansionTile(
                leading: const CircleAvatar(child: Icon(Icons.school)),
                title: Text(collegeName),
                children: [
                  // Try reading campuses as a subcollection (preferred)
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: collegesRef
                        .doc(college.id)
                        .collection('campuses')
                        .orderBy('name')
                        .snapshots(),
                    builder: (context, campusSnapshot) {
                      if (campusSnapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(height: 60, child: Center(child: CircularProgressIndicator())),
                        );
                      }

                      final campusDocs = campusSnapshot.data?.docs;
                      if (campusDocs != null && campusDocs.isNotEmpty) {
                        // Build from campus documents (subcollection)
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: campusDocs.length,
                          itemBuilder: (context, i) {
                            final DocumentSnapshot<Map<String, dynamic>> campus = campusDocs[i];
                            final campusData = campus.data();
                            final campusName = (campusData?['name'] as String?) ?? 'Unnamed Campus';

                            // location can be GeoPoint or map {latitude, longitude}
                            String subtitle = 'No location';
                            final loc = campusData?['location'];
                            if (loc is GeoPoint) {
                              subtitle = '${loc.latitude}, ${loc.longitude}';
                            } else if (loc is Map) {
                              final lat = loc['latitude']?.toString() ?? '';
                              final lon = loc['longitude']?.toString() ?? '';
                              if (lat.isNotEmpty || lon.isNotEmpty) subtitle = '$lat, $lon';
                            }

                            return ListTile(
                              leading: const Icon(Icons.location_city),
                              title: Text(campusName),
                              subtitle: Text(subtitle),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OutletsScreen(
                                      campusName: campusName,
                                      collegeId: college.id,
                                      campusId: campus.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      // Fallback: maybe campuses are stored as an array inside the college document
                      final collegeData = college.data();
                      final rawCampuses = collegeData?['campuses'] as List<dynamic>?;
                      if (rawCampuses == null || rawCampuses.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No campuses available'),
                        );
                      }

                      // Build from the campuses array inside the college document
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rawCampuses.length,
                        itemBuilder: (context, i) {
                          final campusMap = (rawCampuses[i] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
                          final campusName = (campusMap['name'] as String?) ?? 'Unnamed Campus';

                          String subtitle = 'No location';
                          final loc = campusMap['location'];
                          if (loc is Map) {
                            final lat = loc['latitude']?.toString() ?? '';
                            final lon = loc['longitude']?.toString() ?? '';
                            if (lat.isNotEmpty || lon.isNotEmpty) subtitle = '$lat, $lon';
                          } else if (loc is GeoPoint) {
                            subtitle = '${loc.latitude}, ${loc.longitude}';
                          }

                          return ListTile(
                            leading: const Icon(Icons.location_city),
                            title: Text(campusName),
                            subtitle: Text(subtitle),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OutletsScreen(
                                    campusName: campusName,
                                    campusData: campusMap,
                                    collegeId: college.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
