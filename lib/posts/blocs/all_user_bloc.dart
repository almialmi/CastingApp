// import 'package:appp/lib.dart';
// import 'package:flutter/material.dart';

// import 'package:hydrated_bloc/hydrated_bloc.dart';

// class AllUserBloc extends HydratedBloc<AllUserEvent, AllUserState> {
//   AllUserState get initialState {
//     return super.state ?? AllUserLoad();
//   }

//   final PostRepo postrepository;

//   AllUserBloc({@required this.postrepository})
//       : assert(postrepository != null),
//         super(AllUserLoading());

//   @override
//   Stream<AllUserState> mapEventToState(AllUserEvent event) async* {
//     if (event is AllUserLoad) {
//       yield AllUserLoading();
//       try {
//         final posts = await postrepository.getAllUser();
//         yield AllUserLoadSuccess(posts: posts);
//       } catch (e) {
//         print(e);
//         yield AllUserOperationFailure();
//       }
//     }
//   }

//   @override
//   AllUserState fromJson(Map<String, dynamic> json) {
//     try {
//       final post = Post.fromJson(json);
//       if (post == null) {
//         return AllUserOperationFailure();
//       }
//       post.post.removeWhere((element) => element == null);
//       if (post.post.length == 0) return AllUserOperationFailure();
//       return AllUserLoadSuccess(posts: post);
//     } catch (e, a) {
//       // print(" FROM JSON IN EVENTS ${e.toString()}");
//       return AllUserOperationFailure();
//     }
//   }

//   @override
//   Map<String, dynamic> toJson(AllUserState state) {
//     try {
//       if (state is AllUserLoadSuccess) {
//         if (state.posts == null) {
//           return null;
//         }
//         return state.posts.toJson();
//       }
//     } catch (e, a) {
//       return null;
//     }
//     return null;
//   }
// }
