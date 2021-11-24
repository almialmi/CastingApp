import 'package:appp/lib.dart';
import 'package:appp/posts/blocs/post_state.dart';
import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class PostBloc extends HydratedBloc<PostEvent, PostState> {
  PostState get initialState {
    return super.state ?? AllUserLoad();
  }

  final PostRepo postrepository;

  PostBloc({@required this.postrepository})
      : assert(postrepository != null),
        super(PostLoading());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostCreate) {
      try {
        await postrepository.createUser(
            event.post, event.image[0], event.image[1], event.image[2]);
        final ideas = await postrepository.getAllUser();
        yield PostLoadSuccess(posts: ideas, categoryID: event.categoryId);
        yield AllUserLoadSuccess(posts: ideas);
      } catch (_) {
        yield PostOperationFailure();
      }
    }
    if (event is PostLoad) {
      // yield PostLoading();
      try {
        femalePages = (this.state is PostLoadSuccess)
            ? ((this.state as PostLoadSuccess).categoryID == event.categoryId
                ? femalePages
                : 0)
            : 0;
        final posts = await postrepository.getfemalepost(
            event.categoryId, event.gender, femalePages++);

        if (this.state is PostLoadSuccess &&
            (this.state as PostLoadSuccess).categoryID == event.categoryId) {
          posts.post = [
            ...(this.state as PostLoadSuccess).posts.post,
            ...posts.post
          ];
        }
        yield PostLoadSuccess(posts: posts, categoryID: event.categoryId);
      } catch (e) {
        yield PostOperationFailure();
      }
    }

    if (event is AllUserLoad) {
      // yield PostLoading();
      try {
        final posts = await postrepository.getAllUser();

        yield AllUserLoadSuccess(posts: posts);
      } catch (e) {
        yield PostOperationFailure();
      }
    }

    if (event is ProfileUpdate) {
      try {
        await postrepository.updateUserProfile(event.post);
        final eventt = await postrepository.getAllUser();
        yield PostLoadSuccess(posts: eventt, categoryID: event.categoryID);
        yield AllUserLoadSuccess(posts: eventt);
      } catch (e) {
        print(e);
        yield PostOperationFailure();
      }
    }

    

    if (event is PostDelete) {
      try {
        await postrepository.deleteUser(event.post);
        final post = await postrepository.getAllUser();
        yield PostLoadSuccess(posts: post, categoryID: event.categoryId);
        yield AllUserLoadSuccess(posts: post);
      } catch (e) {
        print(e);
        yield PostOperationFailure();
      }
    }
  }

  @override
  PostState fromJson(Map<String, dynamic> json) {
    try {
      final post = Post.fromJson(json);
      if (post == null) {
        return PostOperationFailure();
      }
      post.post.removeWhere((element) => element == null);
      if (post.post.length == 0) return PostOperationFailure();
      return AllUserLoadSuccess(posts: post);
    } catch (e, a) {
      // print(" FROM JSON IN EVENTS ${e.toString()}");
      return PostOperationFailure();
    }
  }

  @override
  Map<String, dynamic> toJson(PostState state) {
    try {
      if (state is AllUserLoadSuccess) {
        if (state.posts == null) {
          return null;
        }
        return state.posts.toJson();
      }
    } catch (e, a) {
      return null;
    }
    return null;
  }

  
}
