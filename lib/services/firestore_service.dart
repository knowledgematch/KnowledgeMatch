import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knowledgematch/model/notification_data.dart';

class FirestoreService {
  Future<List<NotificationData>> fetchNotifications({
    required int userID,
    required NotificationType type
  }) async {
    try {
      QuerySnapshot sourceSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('sourceUserId', isEqualTo: userID.toString())
          .get();

      QuerySnapshot targetSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('targetUserId', isEqualTo: userID.toString())
          .get();

      List<QueryDocumentSnapshot> allDocs = [...sourceSnapshot.docs, ...targetSnapshot.docs];

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
}
