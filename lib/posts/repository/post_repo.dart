import 'dart:io';

import 'package:appp/lib.dart';
import 'package:appp/posts/provider/post_pro.dart';

class PostRepo {
  PostProvider postProvider;

  PostRepo() : assert(PostProvider != null) {
    PostProvider.getInstance().then((value) {
      this.postProvider = value;
    });
  }
  Future<Userr> getLoggedInUser() async {
    while (true) {
      if (this.postProvider == null) {
        this.postProvider = await PostProvider.getInstance();
      } else {
        break;
      }
    }
    return this.postProvider.getLoggedInUser();
  }

  Future<String> createUser(
      PostElement post, File file, File file1, File file2) async {
    //print("image is $image");
    return await postProvider.createUser(post, file, file1, file2);
  }

  Future<Post> getfemalepost(String categoryId, String gender, int page) async {
    return await postProvider.getPosts(categoryId, gender, page);
  }

  Future<Post> getAllUser() async {
    return await postProvider.getAllUsers();
  }

  Future<String> deleteUser(String id) async {
    return await postProvider.deleteUser(id);
  }

  Future<int> updateLike(String postownerid, String loggedinuser) async {
    return await postProvider.updateLike(postownerid, loggedinuser);
  }

  Future<int> updateDislike(
    String postownerid,
    String loggedinuser,
  ) async {
    return await postProvider.updateDislike(
      postownerid,
      loggedinuser,
    );
  }

  Future<String> updateUserProfile(PostElement element) async {
    return await postProvider.updateUserProfile(element);
  }
}
