const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendToDevice = functions.https.onCall(async (data, context) => {
  const {token, title, body}= data;
  console.log(token);
  console.log(title);
  console.log(body);
  const message = {
    notification: {
      title: "title",
      body: "body",
    },
    token: "eA5YhA32RJWALJsDphXdfG:APA91bEh6s3D7vlrk"+
    "0RkL4FlicsBqDi4o63HxNnnSIYiEyaw6XspZ9JO7H7mZ2bDBHTE_"+
    "zenOzVucVhfbsMlttO-2YO-B8JgK9RCcZrFzWTRArxuiNMsd4U",
  };

  try {
    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);
    return {success: true};
  } catch (error) {
    console.error("Error sending message:", error);
    return {success: false, error: error.message};
  }
});
