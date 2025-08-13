import 'package:get/get.dart';
import '../../../data/outletmodel/outletmodel.dart';
import '../../../services/firestore/firestore_service.dart';

class OutletsController {
  final _service = FirestoreService();

  Stream<List<Outlet>> getOutlets(String collegeId, String campusId) {
    return _service.getOutlets(collegeId, campusId);
  }
}
