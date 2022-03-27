import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
const fcm = admin.messaging();
export const sendToTopic = functions.firestore
  .document('puppies/{puppyId}')
  .onCreate(async snapshot => {
//    const puppy = snapshot.data();
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Presence App',
        body: `Support is needed`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic('support', payload);
  });