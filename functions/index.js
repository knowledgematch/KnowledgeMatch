const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendToDevice = functions.https.onCall(async (data, context) => {
  const { targetToken, title, body } = data;

  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: targetToken,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return { success: true };
  } catch (error) {
    console.error('Error sending message:', error);
    return { success: false, error: error.message };
  }
});
