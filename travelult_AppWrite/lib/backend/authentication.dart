import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

//Remove API Keys from authentication
enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthAPI extends ChangeNotifier {
  Client client = Client();
  late final Account account;

  late User _currentUser;

  AuthStatus _status = AuthStatus.uninitialized;

  //Getter Methods
  User get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get userName => _currentUser.name;
  String? get email => _currentUser.email;
  String? get userID => _currentUser.$id;

  //Constructor
  AuthAPI() {
    init();
    loadUser();
  }
  // Initialize the Appwrite client
  init() {
    client
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("64750a688256f3697ab1")
        .setSelfSigned(status: false);
    account = Account(client);
  }

  loadUser() async {
    try {
      final user = await account.get();
      _status = AuthStatus.authenticated;
      _currentUser = user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<User> createdUser(
      {required String email,
      required String password,
      required String fullName,
      required BuildContext context}) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: fullName,
      );
      return user;
    } finally {
      notifyListeners();
    }
  }

  Future<Session> createEmailSession(
    String email,
    String password,
  ) async {
    try {
      final session = await account.createEmailSession(
        email: email,
        password: password,
      );
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  googleSignInProvider(String provider) async {
    try {
      final session = await account.createOAuth2Session(provider: provider);
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  logOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<Preferences> getUserPreferences() async {
    return await account.getPrefs();
  }

  updatePreferences({required String notes}) async {
    return account.updatePrefs(prefs: {'notes': notes});
  }
}


// Future postDetailsToFirebaseStorage(
//     number, fullname, FirebaseAuth auth, BuildContext context) async {
//   // calling firebaseStorage
//   FirebaseStorage firebaseStorage = FirebaseStorage.instance;
//   User? user = auth.currentUser;
//   UserModel userModel = UserModel();

//   //writing in the firebaseStorage

//   userModel.email = user!.email;
//   userModel.uid = user.uid;
//   userModel.phoneNumber = number;
//   userModel.fullname = fullname;
//   userModel.dateTime = DateTime.now();
//   final ref = firebaseStorage
//       .ref()
//       .child("Users")
//       .child(user.uid)
//       .child("${user.uid}.json");
//   await ref
//       .putString(
//     userModel.toMap().toString(),
//     metadata: SettableMetadata(customMetadata: {
//       'contentType': "application/json",
//     }),
//   )
//       .then((p0) async {
//     final bool booldata = auth.currentUser!.providerData
//         .toString()
//         .contains("providerId: google.com");
//     if (booldata == false) {
//       verifyUser(user, context);
//       await FirebaseAuth.instance.signOut();
//     }
//   });
// }