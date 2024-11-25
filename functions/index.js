const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendToDevice = functions.https.onCall(async (request) => {
  const targetToken = request.data.token;
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
      token: targetToken,
    };
    await admin.messaging().send(message);
    return {success: true};
  } catch (error) {
    return {success: false, error: error.toString()};
  }
});
