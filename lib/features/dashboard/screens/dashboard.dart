import 'package:flutter/material.dart';
import 'package:liftapp/features/dashboard/screens/outlets.dart';
import '../../../data/campusmodel/campus_model.dart';
import '../../../data/college_model.dart';
import '../controller/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  final controller = DashboardController();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: StreamBuilder<List<College>>(
        stream: controller.getColleges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No colleges available"));
          }

          final colleges = snapshot.data!;

          return ListView.builder(
            itemCount: colleges.length,
            itemBuilder: (context, collegeIndex) {
              final college = colleges[collegeIndex];

              return ExpansionTile(
                leading: const Icon(Icons.school),
                title: Text(college.name),
                children: [
                  StreamBuilder<List<Campus>>(
                    stream: controller.getCampuses(college.id),
                    builder: (context, campusSnapshot) {
                      if (campusSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!campusSnapshot.hasData || campusSnapshot.data!.isEmpty) {
                        return const ListTile(title: Text("No campuses found"));
                      }

                      final campuses = campusSnapshot.data!;

                      return Column(
                        children: campuses.map((campus) {
                          return ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(campus.name),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OutletsScreen(
                                    collegeId: college.id,
                                    campusName: campus.name,
                                    campusId: campus.id,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
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
