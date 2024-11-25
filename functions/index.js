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
    await admin.messaging().send(message);
    return {success: true};
  } catch (error) {
    return {success: false, error: error.toString()};
  }
});
