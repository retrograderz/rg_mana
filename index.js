const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  // Kiểm tra xem yêu cầu có đến từ admin hay không
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError('permission-denied', 'Unauthorized');
  }

  const userId = data.userId;

  try {
    // Xóa người dùng trên Firebase Authentication
    await admin.auth().deleteUser(userId);

    // Xóa người dùng trong Firestore (nếu cần)
    await admin.firestore().collection('Users').doc(userId).delete();

    return { message: `User with ID ${userId} has been deleted.` };
  } catch (error) {
    throw new functions.https.HttpsError('unknown', `Failed to delete user: ${error.message}`);
  }
});
