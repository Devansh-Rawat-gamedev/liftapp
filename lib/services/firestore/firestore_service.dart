import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/campusmodel/campus_model.dart';
import '../../data/college_model.dart';
import '../../data/menudata/menumodel.dart';
import '../../data/outletmodel/outletmodel.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<College>> getColleges() {
    return _db.collection('colleges').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => College.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<Campus>> getCampuses(String collegeId) {
    return _db
        .collection('colleges')
        .doc(collegeId)
        .collection('campuses')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Campus.fromFirestore(doc)).toList());
  }

  Stream<List<Outlet>> getOutlets(String collegeId, String campusId) {
    return _db
        .collection('colleges')
        .doc(collegeId)
        .collection('campuses')
        .doc(campusId)
        .collection('outlets')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Outlet.fromMap(doc.id, doc.data()))
        .toList());
  }

  Stream<List<MenuItem>> getMenu(String collegeId, String campusId, String outletId) {
    return _db
        .collection('colleges')
        .doc(collegeId)
        .collection('campuses')
        .doc(campusId)
        .collection('outlets')
        .doc(outletId)
        .collection('menu')
        .orderBy('name')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => MenuItem.fromMap(doc.data())).toList());
  }
}
