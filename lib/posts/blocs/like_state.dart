
import 'package:equatable/equatable.dart';

abstract class LikeDislikeState extends Equatable {
  const LikeDislikeState();
  @override
  List<Object> get props => [];
}

class LikeInitState extends LikeDislikeState {}

class LikeUpdated extends LikeDislikeState {
  final String postownerid;
  final String loggedinuser;
  int likes;
  int dislikes;
  // value true if it is like event response  , false other wise ( if it's dislike )
  bool liked;
  LikeUpdated({this.postownerid, this.loggedinuser, int likes, int dislike});
  LikeUpdated.liked({this.postownerid, this.loggedinuser, this.likes}) {
    this.liked = true;
  }
  LikeUpdated.disliked({this.postownerid, this.loggedinuser, this.dislikes}) {
    this.liked = false;
  }

  @override
  List<Object> get props => [postownerid];
}

class DisLikeUpdated extends LikeDislikeState {
  final String postownerid;
  final String loggedinuser;
  int likes;
  int dislikes;
  // value true if it is like event response  , false other wise ( if it's dislike )
  bool liked;
  DisLikeUpdated({this.postownerid, this.loggedinuser, int likes, int dislike});
  DisLikeUpdated.liked({this.postownerid, this.loggedinuser, this.likes}) {
    this.liked = true;
  }
  DisLikeUpdated.disliked(
      {this.postownerid, this.loggedinuser, this.dislikes}) {
    this.liked = false;
  }

  @override
  List<Object> get props => [postownerid];
}
