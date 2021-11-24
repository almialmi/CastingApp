
import 'package:equatable/equatable.dart';

abstract class LikeDislikeEvent extends Equatable {
  const LikeDislikeEvent();
}


class LikeUpdate extends LikeDislikeEvent{
  final String postownerid;
  final String loggedinuser;
  const LikeUpdate(this.postownerid, this.loggedinuser);
  @override
  List<Object> get props => [loggedinuser];

  @override
  toString() => 'post updated {post: $loggedinuser}';
}

class DislikeUpdate extends LikeDislikeEvent{
  final String postownerid;
  final String loggedinuser;
  const DislikeUpdate(this.postownerid, this.loggedinuser);
  @override
  List<Object> get props => [loggedinuser];

  @override
  toString() => 'post updated {post: $loggedinuser}';
}



