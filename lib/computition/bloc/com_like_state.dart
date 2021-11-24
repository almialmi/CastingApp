
import 'package:equatable/equatable.dart';

abstract class LikeDislikeCompState extends Equatable {
  const LikeDislikeCompState();
  @override
  List<Object> get props => [];
}

class LikeInitStateComp extends LikeDislikeCompState {}

class LikeUpdatedComp extends LikeDislikeCompState {
  final String postownerid;
  final String loggedinuser;
  int likes;
  int dislikes;
  // value true if it is like event response  , false other wise ( if it's dislike )
  bool liked;
  LikeUpdatedComp({this.postownerid, this.loggedinuser, int likes, int dislike});
  LikeUpdatedComp.liked({this.postownerid, this.loggedinuser, this.likes}) {
    this.liked = true;
  }
  LikeUpdatedComp.disliked({this.postownerid, this.loggedinuser, this.dislikes}) {
    this.liked = false;
  }

  @override
  List<Object> get props => [postownerid];
}

class DisLikeUpdatedComp extends LikeDislikeCompState {
  final String postownerid;
  final String loggedinuser;
  int likes;
  int dislikes;
  // value true if it is like event response  , false other wise ( if it's dislike )
  bool liked;
  DisLikeUpdatedComp({this.postownerid, this.loggedinuser, int likes, int dislike});
  DisLikeUpdatedComp.liked({this.postownerid, this.loggedinuser, this.likes}) {
    this.liked = true;
  }
  DisLikeUpdatedComp.disliked(
      {this.postownerid, this.loggedinuser, this.dislikes}) {
    this.liked = false;
  }

  @override
  List<Object> get props => [postownerid];
}
