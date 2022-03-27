import 'package:careing/presence.dart';

class DynamicLinkService {
  final firestoreInstance = FirebaseFirestore.instance;

  Future<String> handleLinkData(PendingDynamicLinkData data) async {
    if (data != null) {
      print('data not null');
      final Uri deepLink = data.link;
      print('deepLink ' + deepLink.toString());
      var isWordie = deepLink.pathSegments.contains('post');
      var wordLink = deepLink.queryParameters['presence'];
      if (isWordie && wordLink != null) {
        var wordLink = deepLink.queryParameters['presence'];
        print('wordlink is ' + wordLink.toString());
        return wordLink;
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  Future<String> isLinkValid() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    print('data null');
    if (data != null) {
      print('data not null');
      final Uri deepLink = data.link;
      print('deepLink ' + deepLink.toString());
      var isWordie = deepLink.pathSegments.contains('post');
      var wordLink = deepLink.queryParameters['presence'];
      if (isWordie && wordLink != null) {
        var UIDLink = deepLink.queryParameters['presence'];
        print('sharing user UID is ' + UIDLink.toString());
        return UIDLink;
        // var collection = FirebaseFirestore.instance.collection('challenges');
        // var docSnapshot = await collection.doc(wordLink.toString()).get();
        // if (docSnapshot.exists) {
        //   Map<String, dynamic> data = docSnapshot.data();

        //   // You can then retrieve the value from the Map like this:
        //   String word = data['word'].toString();
        //   print('word is ' + word);
        //   return word;
        // } else {
        //   print('word is empty');
        //   return '';
        // }
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  Future<String> uploadChallengeLink(String word) async {
    DocumentReference ref =
        await firestoreInstance.collection("challenges").add({
      "word": word,
    });
    print(ref.id);
    return ref.id;
  }

  Future<String> getSupporterLink() async {
    String UID = 'ABCD';
    // print("userUID " + FirebaseAuth.instance.currentUser.uid.toString());
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://sabresmediapresence.page.link',
      link: Uri.parse('https://www.sabresmedia.com/post?presence=${UID}'),

      androidParameters: AndroidParameters(
        packageName: 'com.sabresmedia.presence',
        minimumVersion: 0,
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      iosParameters: IOSParameters(
        bundleId: 'com.sabresmedia.presence',
        minimumVersion: '0',
        appStoreId: '123456789',
      ),
      // googleAnalyticsParameters: GoogleAnalyticsParameters(
      //   campaign: 'example-promo',
      //   medium: 'social',
      //   source: 'orkut',
      // ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: 'Example of a Dynamic Link',
      //   description: 'This link works whether app is installed or not!',
      // ),
    );

    // final ShortDynamicLink shortDynamicLink =
    //     await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    // final Uri uri = shortDynamicLink.shortUrl;
    final Uri uri = await FirebaseDynamicLinks.instance.buildLink(parameters);
    return uri.toString();
  }
}
