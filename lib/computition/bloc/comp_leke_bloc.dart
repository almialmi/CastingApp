import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LikeDislikeCompBloc
    extends Bloc<LikeDislikeEventComp, LikeDislikeCompState> {
  final ComputationRepo comprepository;

  LikeDislikeCompBloc({@required this.comprepository})
      : assert(comprepository != null),
        super(LikeInitStateComp());

  @override
  Stream<LikeDislikeCompState> mapEventToState(
      LikeDislikeEventComp event) async* {
    if (event is LikeUpdateComp) {
      try {
        final val = await comprepository.updateLike(
            event.postownerid, event.loggedinuser);

        final value = LikeUpdatedComp.liked(
          postownerid: event.postownerid,
          loggedinuser: event.loggedinuser,
          likes: val,
        );
        yield LikeInitStateComp();
        yield value;
      } catch (e) {
        print("LIKE ERROR : ${e.toString()}");
        //yield PostOperationFailure();
      }
    }

    if (event is DislikeUpdateComp) {
      try {
        int val = await comprepository.updateDislike(
            event.postownerid, event.loggedinuser);
        //final post = await postrepository.getAllUser();
        // yield PostLoadSuccess(post);
        final van = DisLikeUpdatedComp.disliked(
          postownerid: event.postownerid,
          loggedinuser: event.loggedinuser,
          dislikes: val,
        );
        yield LikeInitStateComp();
        yield van;
        print("-------------------------------------------------------------");
      } catch (e) {
        print("Dis ERROR : ${e.toString()}");

        //yield PostOperationFailure();
      }
    }
  }
}
