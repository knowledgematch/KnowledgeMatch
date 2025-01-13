import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knowledgematch/models/notification_data.dart';

class FirestoreService {
  /// Fetches notifications for a specific user with an optional filter for notification type.
  ///
  /// Queries the `notifications` collection for notifications where the
  /// `target_user_id` matches the given user ID and `is_open` is true.
  /// Results are ordered by timestamp in descending order.
  ///
  /// Parameters:
  /// - `userID`: The ID of the user whose notifications are being fetched.
  /// - `type` (optional): The type of notifications to filter by.
  ///
  /// Returns:
  /// A future that resolves to a list of `NotificationData` objects.
  Future<List<NotificationData>> fetchNotifications(
      {required int userID, NotificationType? type}) async {
    try {
      QuerySnapshot targetSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where(Filter.and(
              Filter('target_user_id', isEqualTo: userID.toString()),
              Filter('is_open', isEqualTo: true.toString())))
          .orderBy('timestamp', descending: true)
          .get();

      return _buildList(targetSnapshot: targetSnapshot);
    } catch (error) {
      print('Error fetching notifications: $error');
      rethrow;
    }
  }

  /// Fetches confirmed notifications for a specific user.
  ///
  /// Queries the `notifications` collection for notifications where the
  /// `target_user_id` matches the given user ID and the `notification_type`
  /// is a meetup confirmation. Results are ordered by timestamp in descending order.
  ///
  /// Parameters:
  /// - `userID`: The ID of the user whose confirmed notifications are being fetched.
  ///
  /// Returns:
  /// A future that resolves to a list of `NotificationData` objects.
  Future<List<NotificationData>> fetchConfirmed({required int userID}) async {
    try {
      QuerySnapshot targetSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where(Filter.and(
              Filter('target_user_id', isEqualTo: userID.toString()),
              Filter('notification_type',
                  isEqualTo:
                      NotificationType.meetupConfirmation.toShortString())))
          .orderBy('timestamp', descending: true)
          .get();

      return _buildList(targetSnapshot: targetSnapshot);
    } catch (error) {
      print('Error fetching notifications: $error');
      rethrow;
    }
  }

  /// Builds a list of `NotificationData` objects from a `QuerySnapshot`.
  ///
  /// This method extracts the documents from the provided `QuerySnapshot`,
  /// converts their data into a list of maps, and transforms them into
  /// `NotificationData` objects.
  ///
  /// Parameters:
  /// - `targetSnapshot`: The snapshot containing the documents to process.
  ///
  /// Returns:
  /// A future that resolves to a [List] of [NotificationData] objects.
  Future<List<NotificationData>> _buildList(
      {required QuerySnapshot targetSnapshot}) async {
    List<QueryDocumentSnapshot> allDocs = [...targetSnapshot.docs];
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
