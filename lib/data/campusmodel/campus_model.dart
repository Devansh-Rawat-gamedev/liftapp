import 'package:cloud_firestore/cloud_firestore.dart';
import '../outletmodel/outletmodel.dart';

class Campus {
  final String id;
  final String name;
  final String location;
  final List<Outlet> outlets;

  Campus({
    required this.id,
    required this.name,
    required this.location,
    this.outlets = const [],
  });

  factory Campus.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    String location = 'No location';
    final loc = data['location'];
    if (loc is GeoPoint) {
      location = '${loc.latitude}, ${loc.longitude}';
    } else if (loc is Map) {
      final lat = loc['latitude'] ?? '';
      final lon = loc['longitude'] ?? '';
      location = '$lat, $lon';
    }
    return Campus(
      id: doc.id,
      name: data['name'] ?? '',
      location: location,
    );
  }
}
