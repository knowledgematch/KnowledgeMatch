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

  // Generate an Id in the 'notificaitons' collection
  const documentID = firestore.collection("notifications").doc().id;

  // if no requestId has been passed to the cloudfunction
  // -> sets the requestId to the documentID
  let requestId = request.data.request_id;
  if (!requestId) {
    requestId = documentID;
  }

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
        timestamp: timestamp,
        payload: JSON.stringify(payload),
        request_id: requestId,
        document_id: documentID,
        is_open: true.toString(),
      },
      tokens: tokens,
    };

    // Send the notification to multiple devices
    const response = await admin.messaging().sendEachForMulticast(message);
    console.log("Successfully sent messages:", response);

    // Save notification to firestore
    await firestore.collection("notifications").doc(documentID).set({
      source_user_id: sourceUserId,
      target_user_id: targetUserId,
      tokens: tokens,
      title: title,
      body: body,
      notification_type: notificationType,
      payload: payload,
      is_open: true.toString(),
      successCount: response.successCount,
      timestamp: timestamp,
      request_id: requestId,
    });

    console.log(
      "Single notification doc saved to Firestore with ID:",
      documentID,
    );

    return { success: true, successCount: response.successCount };
  } catch (error) {
    console.error("Error sending message:", error);
    return { success: false, error: error.toString() };
  }
});
