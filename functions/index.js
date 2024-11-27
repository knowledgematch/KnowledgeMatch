const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const firestore = admin.firestore();

exports.sendToDevice = functions.https.onCall(async (request) => {
  const tokens = request.data.tokens;
  const title = request.data.title;
  const body = request.data.body;
  const targetUserId = request.data.target_user_id;
  const sourceUserId = request.data.source_user_id;
  const notificationType = request.data.notification_type;

  try {
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
        sourceUserId: sourceUserId,
        targetUserId: targetUserId,
        token: token,
        title: title,
        body: body,
        notificationType: notificationType,
        success: success,
        error: error,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
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
