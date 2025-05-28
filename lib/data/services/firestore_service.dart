import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';

class FirestoreService {
  String firestoreCollection = "";

  FirestoreService() {
    if (kReleaseMode) {
      firestoreCollection = "notifications";
    } else {
      firestoreCollection = "test_notifications";
    }
  }

  /// Fetches notifications for a specific user with an optional filter for request type.
  ///
  /// Queries the `notifications` collection for notifications where the
  /// `target_user_id` matches the given user ID.
  /// Results are ordered by timestamp in descending order.
  ///
  /// Parameters:
  /// - `userID`: The ID of the user whose notifications are being fetched.
  /// - 'isOpen?': Optional, If it should return only notifications with status isOpen
  ///
  /// Returns:
  /// A future that resolves to a list of `NotificationData` objects.
  Future<List<NotificationData>> fetchNotifications({
    required int userID,
    bool? isOpen,
  }) async {
    try {
      QuerySnapshot targetSnapshot =
          await FirebaseFirestore.instance
              .collection(firestoreCollection)
              .where(
                isOpen == true
                    ? Filter.and(
                      Filter('target_user_id', isEqualTo: userID.toString()),
                      Filter('is_open', isEqualTo: true.toString()),
                    )
                    : Filter('target_user_id', isEqualTo: userID.toString()),
              )
              .orderBy('timestamp', descending: true)
              .get();

      return _buildList(targetSnapshot: targetSnapshot);
    } catch (error) {
      print('Error fetching notifications: $error');
      rethrow;
    }
  }

  /// Opens a Stream of open Notifications from Firestore
  ///
  /// Listens to Firestore documents in the `notifications` collection where:
  /// - `target_user_id` matches the provided [userID]
  /// - `is_open` matches the provided [isOpen] flag
  ///
  /// Maps Documents to [NotificationData] -> (see[NotificationData.fromFirestoreData])
  ///
  /// Returns:
  /// A stream of lists of [NotificationData].
  Stream<List<NotificationData>> openNotificationsStream({
    required int userID,
    required bool isOpen,
  }) {
    return FirebaseFirestore.instance
        .collection(firestoreCollection)
        .where(
          Filter.and(
            Filter('target_user_id', isEqualTo: userID.toString()),
            Filter('is_open', isEqualTo: isOpen.toString()),
          ),
        )
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return NotificationData.fromFirestoreData(
              jsonMap: data,
              documentID: doc.id,
            );
          }).toList();
        });
  }

  /// Opens a Stream of confirmed Notifications from Firestore
  ///
  /// Listens to Firestore documents in the `notifications` collection where:
  /// - `target_user_id` matches the provided [userID]
  /// - `notification_type` matches the provided [NotificationType.meetupConfirmation]
  ///
  /// Maps Documents to [NotificationData] -> (see[NotificationData.fromFirestoreData])
  ///
  /// Returns:
  /// A stream of lists of [NotificationData].
  Stream<List<NotificationData>> confirmedNotificationsStream({
    required int userID,
  }) {
    return FirebaseFirestore.instance
        .collection(firestoreCollection)
        .where(
          Filter.and(
            Filter('target_user_id', isEqualTo: userID.toString()),
            Filter(
              'notification_type',
              isEqualTo: NotificationType.meetupConfirmation.toShortString(),
            ),
          ),
        )
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return NotificationData.fromFirestoreData(
              jsonMap: data,
              documentID: doc.id,
            );
          }).toList();
        });
  }

  /// Opens a Stream of open Notifications from Firestore
  ///
  /// Listens to Firestore documents in the `notifications` collection where:
  /// - `source_user_id` matches the provided [userID]
  /// - `is_open` matches the provided [isOpen] flag
  ///
  /// Maps Documents to [NotificationData] -> (see[NotificationData.fromFirestoreData])
  ///
  /// Returns:
  /// A stream of lists of [NotificationData].
  Stream<List<NotificationData>> pendingNotificationsStream({
    required int userID,
    required bool isOpen,
  }) {
    return FirebaseFirestore.instance
        .collection(firestoreCollection)
        .where(
          Filter.and(
            Filter('source_user_id', isEqualTo: userID.toString()),
            Filter('is_open', isEqualTo: isOpen.toString()),
          ),
        )
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return NotificationData.fromFirestoreData(
              jsonMap: data,
              documentID: doc.id,
            );
          }).toList();
        });
  }

  Stream<List<NotificationData>> allNotificationsStream({required int userID}) {
    return FirebaseFirestore.instance
        .collection(firestoreCollection)
        .where(
          Filter.or(
            Filter('target_user_id', isEqualTo: userID.toString()),
            Filter('source_user_id', isEqualTo: userID.toString()),
          ),
        )
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return NotificationData.fromFirestoreData(
              jsonMap: data,
              documentID: doc.id,
            );
          }).toList();
        });
  }

  /// Fetches notifications for a specific user with an optional filter for request type.
  ///
  /// Queries the `notifications` collection for notifications where the
  /// `target_user_id` or the 'source_user_id' matches the given user ID.
  /// Results are ordered by timestamp in descending order.
  ///
  /// Parameters:
  /// - `userID`: The ID of the user whose notifications are being fetched.
  ///
  /// Returns:
  /// A future that resolves to a list of `NotificationData` objects.
  Future<List<NotificationData>> fetchAllNotifications({
    required int userID,
  }) async {
    try {
      QuerySnapshot targetSnapshot =
          await FirebaseFirestore.instance
              .collection(firestoreCollection)
              .where(
                Filter.or(
                  Filter('target_user_id', isEqualTo: userID.toString()),
                  Filter('source_user_id', isEqualTo: userID.toString()),
                ),
              )
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
      QuerySnapshot targetSnapshot =
          await FirebaseFirestore.instance
              .collection(firestoreCollection)
              .where(
                Filter.and(
                  Filter('target_user_id', isEqualTo: userID.toString()),
                  Filter(
                    'notification_type',
                    isEqualTo:
                        NotificationType.meetupConfirmation.toShortString(),
                  ),
                ),
              )
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
  Future<List<NotificationData>> _buildList({
    required QuerySnapshot targetSnapshot,
  }) async {
    List<QueryDocumentSnapshot> allDocs = [...targetSnapshot.docs];
    List<Map<String, dynamic>> firestoreData =
        allDocs.map((doc) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }).toList();

    List<NotificationData> notifications =
        firestoreData.map((map) {
          return NotificationData.fromFirestoreData(jsonMap: map);
        }).toList();

    return notifications;
  }

  /// Closes all notifications with matching [requestID]
  ///
  /// sets the [is_open] document Field in Firestore to [false]
  ///
  /// [requestID] : request_id field of documents to close
  Future<void> closeRequest(String? requestID) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection(firestoreCollection)
            .where('request_id', isEqualTo: requestID)
            .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.update({'is_open': false.toString()});
    }
  }

  /// Updates the [is_open] field of the document
  ///
  /// sets the [is_open] field according to [isOpen]
  /// which represents the status of the request
  /// [documentID] : document to change the status of
  Future<void> notificationStatusUpdate(bool isOpen, String? documentID) async {
    if (documentID == null) return;
    await FirebaseFirestore.instance
        .collection(firestoreCollection)
        .doc(documentID)
        .update({'is_open': isOpen.toString()});
  }

  /// Adds a confirmation notification document to Firestore
  ///
  /// Takes the provided [notificationData], swaps the sourceUserId and the targetUserId
  /// as a copy for the user that sends the confirmation
  Future<void> addConfirmationToFirestore(
    NotificationData notificationData,
  ) async {
    final data = {
      'body': notificationData.body,
      'is_open': 'false',
      'notification_type': notificationData.type.toShortString(),
      'payload': notificationData.payload,
      'request_id': notificationData.requestID.toString(),
      'target_user_id':
          notificationData.sourceUserId
              .toString(), //Swap source and target user intentionally
      'source_user_id': notificationData.targetUserId.toString(), //Swap target
      'title': notificationData.title,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await FirebaseFirestore.instance
          .collection(firestoreCollection)
          .add(data);
      print("Confirmation document was successfully added to Firestore");
    } catch (e) {
      print("Error while inserting document: $e");
    }
  }
}
