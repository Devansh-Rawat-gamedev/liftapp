import '../../../data/menudata/menumodel.dart';
import '../../../services/firestore/firestore_service.dart';

class MenuController {
  final _service = FirestoreService();

  Stream<List<MenuItem>> getMenu(String collegeId, String campusId, String outletId) {
    return _service.getMenu(collegeId, campusId, outletId);
  }
}
