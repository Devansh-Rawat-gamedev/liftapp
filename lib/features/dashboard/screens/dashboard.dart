import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collegesRef = FirebaseFirestore.instance.collection('colleges');

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: collegesRef.snapshots(),
        builder: (context, collegeSnapshot) {
          if (collegeSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!collegeSnapshot.hasData || collegeSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No colleges available"));
          }

          final colleges = collegeSnapshot.data!.docs;

          return ListView.builder(
            itemCount: colleges.length,
            itemBuilder: (context, index) {
              final college = colleges[index];
              return ExpansionTile(
                leading: const CircleAvatar(child: Icon(Icons.school)),
                title: Text(college['name']),
                children: [
                  // Fetch campuses for this college
                  StreamBuilder<QuerySnapshot>(
                    stream: collegesRef
                        .doc(college.id)
                        .collection('campuses')
                        .orderBy('name')
                        .snapshots(),
                    builder: (context, campusSnapshot) {
                      if (campusSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!campusSnapshot.hasData || campusSnapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No campuses available"),
                        );
                      }

                      final campuses = campusSnapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: campuses.length,
                        itemBuilder: (context, i) {
                          final campus = campuses[i];
                          return ListTile(
                            leading: const Icon(Icons.location_city),
                            title: Text(campus['name']),
                            subtitle: Text(campus['location']),
                            onTap: () {
                              print("Selected campus: ${campus['name']}");
                              // Navigate to outlets or menu page
                            },
                          );
                        },
                      );
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
