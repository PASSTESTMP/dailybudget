import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailybudget/Model/list_data_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ListDataModel>> getListsForUser(String userId) {
    return _db
        .collection('shoppingLists')
        .where('sharedWith', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => listDataModelFromJson(doc.data()))
            .toList());
  }

  Future<void> saveListFromJson(Map<String, dynamic> listJson) async {
    final docId = listJson['id'];
    await _db.collection('shoppingLists').doc(docId).set(listJson);
  }


  Future<void> deleteList(String listId) async {
    await _db.collection('shoppingLists').doc(listId).delete();
  }

  Future<void> shareList(String listId, String userIdToShareWith) async {
    final doc = _db.collection('shoppingLists').doc(listId);
    await doc.update({
      'sharedWith': FieldValue.arrayUnion([userIdToShareWith])
    });
  }
}
