import 'package:flutter/material.dart';
import '../../../data/outletmodel/outletmodel.dart';
import '../controller/outlets_controller.dart';
import 'menu.dart';

class OutletsScreen extends StatelessWidget {
  final String campusName;
  final String collegeId;
  final String campusId;

  final controller = OutletsController();

  OutletsScreen({
    super.key,
    required this.campusName,
    required this.collegeId,
    required this.campusId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$campusName Outlets")),
      body: StreamBuilder<List<Outlet>>(
        stream: controller.getOutlets(collegeId, campusId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No outlets available"));
          }

          final outlets = snapshot.data!;
          return ListView.builder(
            itemCount: outlets.length,
            itemBuilder: (context, index) {
              final outlet = outlets[index];
              return ListTile(
                leading: const Icon(Icons.store),
                title: Text(outlet.name),
                subtitle: Text(outlet.category),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuScreen(
                        collegeId: collegeId,
                        campusId: campusId,
                        outletId: outlet.id,
                        outletName: outlet.name,
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
