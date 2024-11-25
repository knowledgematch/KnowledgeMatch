const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendToDevice = functions.https.onCall(async (request) => {
  const tokens = request.data.tokens;
  const title = request.data.title;
  const body = request.data.body;

  try {
    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: {
        user_id: request.data.user_id,
        notification_type: request.data.notification_type,
      },
      tokens: tokens,
    };
    const response = await admin.messaging().sendEachForMulticast(message);
    console.log("Successfully sent messages:", response);

    return {success: true, response: response.successCount};
  } catch (error) {
    console.error("Error sending message:", error);
    return {success: false, error: error.toString()};
  }
});
