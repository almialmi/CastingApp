
import 'package:equatable/equatable.dart';

abstract class LikeDislikeEventComp extends Equatable {
  const LikeDislikeEventComp();
}


class LikeUpdateComp extends LikeDislikeEventComp{
  final String postownerid;
  final String loggedinuser;
  const LikeUpdateComp(this.postownerid, this.loggedinuser);
  @override
  List<Object> get props => [loggedinuser];

  @override
  toString() => 'post updated {post: $loggedinuser}';
}

class DislikeUpdateComp extends LikeDislikeEventComp{
  final String postownerid;
  final String loggedinuser;
  const DislikeUpdateComp(this.postownerid, this.loggedinuser);
  @override
  List<Object> get props => [loggedinuser];

  @override
  toString() => 'post updated {post: $loggedinuser}';
}



