import 'package:get/get.dart';

import '../../../data/campusmodel/campus_model.dart';
import '../../../data/college_model.dart';
import '../../../services/firestore/firestore_service.dart';

class DashboardController {
  final _service = FirestoreService();

  Stream<List<College>> getColleges() {
    return _service.getColleges();
  }

  Stream<List<Campus>> getCampuses(String collegeId) {
    return _service.getCampuses(collegeId);
  }

}
