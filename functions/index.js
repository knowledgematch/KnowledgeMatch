const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const firestore = admin.firestore();

exports.sendToDevice = functions.https.onCall(async (request) => {
  const tokens = request.data.tokens;
  const title = request.data.title;
  const body = request.data.body;
  const targetUserId = request.data.target_user_id.toString();
  const sourceUserId = request.data.source_user_id.toString();
  const notificationType = request.data.notification_type;
  const timestamp = new Date().toISOString();
  const payload = request.data.payload;
  const documentID = firestore.collection("temp").doc().id;
  let requestId = request.data.request_id;

  try {
    if (!requestId) {
      requestId = documentID;
    }
    // Create the FCM message
    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: {
        target_user_id: targetUserId,
        source_user_id: sourceUserId,
        notification_type: notificationType,
        timestamp: timestamp,
        payload: JSON.stringify(payload),
        request_id: requestId,
        document_id: documentID,
      },
      tokens: tokens,
    };

    // Send the notification to multiple devices
    const response = await admin.messaging().sendEachForMulticast(message);
    console.log("Successfully sent messages:", response);

    // Save notifications to Firestore
    const notificationsRef = firestore.collection("notifications");

    const savePromises = response.responses.map((result, index) => {
      const token = tokens[index];
      const success = result.success;
      const error = result.error ? result.error.message : null;

      return notificationsRef.add({
        source_user_id: sourceUserId,
        target_user_id: targetUserId,
        token: token,
        title: title,
        body: body,
        notification_type: notificationType,
        payload: payload,
        is_open: true,
        success: success,
        error: error,
        timestamp: timestamp,
        request_id: requestId,
      });
    });

    await Promise.all(savePromises);
    console.log("Notifications saved to Firestore");

    return {success: true, successCount: response.successCount};
  } catch (error) {
    console.error("Error sending message:", error);
    return {success: false, error: error.toString()};
  }
});
