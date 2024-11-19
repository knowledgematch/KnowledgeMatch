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
      token: targetToken,
    };
    await admin.messaging().send(message);
    return {success: true};
  } catch (error) {
    return {success: false, error: error.toString()};
  }
});
