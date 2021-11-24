import 'dart:io';

import 'package:appp/lib.dart';
import 'package:appp/user/model/verify_model.dart';

class UserRepository {
  UserRepository() {
    UserProvider.getInstance().then((prov) {
      this.userProvider = prov;
    });
  }
  UserProvider userProvider;

  Future<Userr> fetchownprofile() async {
    return await userProvider.fetchOwnProfile();
  }

  Future<void> updateUser(Userr user) async {
    return await userProvider.updateUser(user);
  }

  Future<void> updateProfilePic(File file) async {
    return await userProvider.updateprofilepic(file);
  }

  Future<Userr> getLoggedInUser() async {
    while (true) {
      if (this.userProvider == null) {
        this.userProvider = await UserProvider.getInstance();
      } else {
        break;
      }
    }
    return this.userProvider.getLoggedInUser();
  }

  Future<void> signOut() async {
    await this.userProvider.logout();
  }

  Future<bool> isSignedIn() async {
    final currentUser = getLoggedInUser();
    return currentUser != null;
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    return await this.userProvider.signInWithEmailAndPassword(email, password);
  }

  Future<String> registor(String email, String password, String username) async {
   return  await this.userProvider.registor(email, password, username);
  }

  Future<Verify> showverification(String code) async {
    return await userProvider.showverificationmessage(code);
  }
}
