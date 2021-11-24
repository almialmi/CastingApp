import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeDislike extends StatefulWidget {
  final PostElement post;

  const LikeDislike({Key key, this.post}) : super(key: key);

  @override
  _LikeDislikeState createState() => _LikeDislikeState();
}

enum like_status {
  liked,
  disliked,
  none,
}

class _LikeDislikeState extends State<LikeDislike> {
  like_status ls = like_status.none;

  @override
  void initState() {
    loggedinuserid = MyID;
    widget.post.like.removeWhere((element) => element == null);
    widget.post.disLike.removeWhere((element) => element == null);
    SharedPrefHandler.getidvalue().then((appId) {
      loggedinuserid = appId;
    });
    for (int a = 0; a < widget.post.like.length; a++) {
      if (widget.post.like[a] == loggedinuserid) this.ls = like_status.liked;
    }
    for (int b = 0; b < widget.post.disLike.length; b++) {
      if (widget.post.disLike[b] == loggedinuserid)
        this.ls = like_status.disliked;
    }
    super.initState();
  }

  String loggedinuserid;
  @override
  Widget build(BuildContext context) {
    int likevalue = widget.post.like.length;
    int dislikevalue = widget.post.disLike.length;
    SharedPrefHandler.getidvalue().then((appId) {
      loggedinuserid = appId;
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<LikeDislikeBloc, LikeDislikeState>(
          builder: (context, state) {
            if (state is LikeUpdated &&
                (state as LikeUpdated).postownerid == widget.post.id) {
              if ((state as LikeUpdated).liked) {
                print("Like is Called .... ");
                widget.post.disLike
                    .removeWhere((element) => "$element" == loggedinuserid);
                // ----
                int oldlen = widget.post.like.length;
                widget.post.like.removeWhere((element) {
                  return "$element" == loggedinuserid;
                });
                int newLen = widget.post.like.length;
                if (newLen < oldlen) {
                  this.ls = like_status.none;
                } else {
                  widget.post.like.add(loggedinuserid);
                  this.ls = like_status.liked;
                }
              }
            }
            return Row(children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color:
                      ls == like_status.liked ? Colors.lightBlue : Colors.grey,
                ),
                onPressed: () {
                  print("loggedinuserid loggedinuserid $loggedinuserid");
                  final LikeDislikeEvent event =
                      LikeUpdate(widget.post.id, loggedinuserid);
                  BlocProvider.of<LikeDislikeBloc>(context).add(event);
                },
              ),
              Text("${widget.post.like.length}")
            ]);
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        BlocBuilder<LikeDislikeBloc, LikeDislikeState>(
          builder: (context, state) {
            if (state is DisLikeUpdated &&
                (state as DisLikeUpdated).postownerid == widget.post.id) {
              if (!((state as DisLikeUpdated).liked)) {
                widget.post.like
                    .removeWhere((element) => element == loggedinuserid);
                int oldlen = widget.post.disLike.length;
                widget.post.disLike.removeWhere((element) {
                  return element == loggedinuserid;
                });

                int newLen = widget.post.disLike.length;
                if (newLen < oldlen) {
                  this.ls = like_status.none;
                } else {
                  widget.post.disLike.add(loggedinuserid);
                  this.ls = like_status.disliked;
                }
              }
            }
            return Row(children: [
              IconButton(
                  icon: Icon(
                    Icons.thumb_down_sharp,
                    color: ls == like_status.disliked
                        ? Colors.lightBlue
                        : Colors.grey,
                  ),
                  // color: pressAttentionn ? Colors.black : Colors.blue,
                  onPressed: () {
                    final LikeDislikeEvent event =
                        DislikeUpdate(widget.post.id, loggedinuserid);
                    BlocProvider.of<LikeDislikeBloc>(context).add(event);
                  }),
              Text("${widget.post.disLike.length}")
            ]);
          },
        ),
      ],
    );
  }
}
