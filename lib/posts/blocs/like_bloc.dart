import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LikeDislikeBloc extends Bloc<LikeDislikeEvent, LikeDislikeState> {
  final PostRepo postrepository;

  LikeDislikeBloc({@required this.postrepository})
      : assert(postrepository != null),
        super(LikeInitState());

  @override
  Stream<LikeDislikeState> mapEventToState(LikeDislikeEvent event) async* {
    if (event is LikeUpdate) {
      try {
        final val = await postrepository.updateLike(
            event.postownerid, event.loggedinuser);

        final value = LikeUpdated.liked(
          postownerid: event.postownerid,
          loggedinuser: event.loggedinuser,
          likes: val,
        );
        yield LikeInitState();
        yield value;
      } catch (e) {
        print("LIKE ERROR : ${e.toString()}");
        //yield PostOperationFailure();
      }
    }

    if (event is DislikeUpdate) {
      try {
        int val = await postrepository.updateDislike(
            event.postownerid, event.loggedinuser);
        //final post = await postrepository.getAllUser();
        // yield PostLoadSuccess(post);
        final van = DisLikeUpdated.disliked(
          postownerid: event.postownerid,
          loggedinuser: event.loggedinuser,
          dislikes: val,
        );
        yield LikeInitState();
        yield van;
        print("-------------------------------------------------------------");
      } catch (e) {
        print("Dis ERROR : ${e.toString()}");

        //yield PostOperationFailure();
      }
    }
  }
}
