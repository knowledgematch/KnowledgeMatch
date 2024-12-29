import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knowledgematch/model/notification_data.dart';

class FirestoreService {
  Future<List<NotificationData>> fetchNotifications(
      {required int userID, NotificationType? type}) async {
    try {
      QuerySnapshot targetSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where(Filter('target_user_id', isEqualTo: userID.toString()))

          //Filter.or(
          //    Filter('target_user_id', isEqualTo: userID.toString()),
          //    Filter('source_user_id', isEqualTo: userID.toString())))
          .orderBy('timestamp', descending: true)
          .get();

      List<QueryDocumentSnapshot> allDocs = [
        ...targetSnapshot.docs
      ]; //...sourceSnapshot.docs,

      List<Map<String, dynamic>> firestoreData = allDocs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      List<NotificationData> notifications = firestoreData.map((map) {
        return NotificationData.fromFirestoreData(map);
      }).toList();

      return notifications;
    } catch (error) {
      print('Error fetching notifications: $error');
      rethrow;
    }
  }

  /// Closes all notifications with matching [requestID]
  ///
  /// sets the [is_open] document Field in Firestore to [false]
  ///
  /// [requestID] : request_id field of documents to close

  Future<void> closeRequest(String? requestID) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('request_id', isEqualTo: requestID)
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.update({'is_open': false.toString()});
    }
  }

  /// Updates the [is_open] field of the document
  ///
  /// sets the [is_open] field according to [isOpen]
  /// which represents the status of the notification
  /// [documentID] : document to change the status of
  Future<void> notificationStatusUpdate(bool isOpen, String? documentID) async {
    if (documentID == null) return;
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(documentID)
        .update({
      'is_open': isOpen.toString(),
    });
  }
}
