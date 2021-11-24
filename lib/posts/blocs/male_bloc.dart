import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class MaleBloc extends Bloc<MaleEvent, MaleState> {
  final PostRepo postrepository;

  MaleBloc({@required this.postrepository})
      : assert(postrepository != null),
        super(MaleLoading());

  @override
  Stream<MaleState> mapEventToState(MaleEvent event) async* {
    if (event is MaleLoad) {
      // yield MaleLoading();
      try {
        malePages = (this.state is MaleLoadSuccess)
            ? ((this.state as MaleLoadSuccess).categoryId == event.cayegoryId
                ? malePages
                : 0)
            : 0;
        final posts = await postrepository.getfemalepost(
            event.cayegoryId, event.gender, malePages++);
        if ((this.state is MaleLoadSuccess) &&
            (this.state as MaleLoadSuccess).posts.post.length > 0 &&
            (this.state as MaleLoadSuccess).categoryId == event.cayegoryId) {
          posts.post = [
            ...(this.state as MaleLoadSuccess).posts.post,
            ...posts.post
          ];
        }
        yield MaleLoadSuccess(posts: posts, categoryId: event.cayegoryId);
      } catch (e) {
        yield MaleOperationFailure();
      }
    }
  }
}
