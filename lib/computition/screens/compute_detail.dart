import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ComputeDetail extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafoldkey;
  final String eventid;
  final COmputationPost comps;
  const ComputeDetail({Key key, this.comps, this.eventid, this.scafoldkey})
      : super(key: key);

  @override
  _ComputeDetailState createState() => _ComputeDetailState();
}

class _ComputeDetailState extends State<ComputeDetail> {
  // String role_user;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  bool pressAttention = false;
  bool pressAttentionn = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.comps.video,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SharedPrefHandler.getrolevalue().then((value) => ROLE = value);
    // SharedPrefHandler.getrolevalue().then((role) {
    //   setState(() {
    //     role_user = role;
    //   });
    // });
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 20),
        elevation: 4,
        //color: Colors.white70,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: [
                        // ProfileImage(image: widget.comps.user.photo1.data.data),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.comps.user.firstName +
                              " " +
                              widget.comps.user.lastName,

                          // posts[idx].post[idx].firstName + posts[idx].post[idx].lastName,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Spacer(),
                        if (ROLE == "Admin")
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showAlertDialog(context);
                              }),
                        if (ROLE == "Admin")
                          IconButton(
                              icon: Icon(Icons.rotate_right_outlined),
                              onPressed: () {
                                _showrequestDialog(context);
                              }),
                      ],
                    ),
                  ),
                  YoutubePlayerBuilder(
                      onExitFullScreen: () {
                        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                        SystemChrome.setPreferredOrientations(
                            DeviceOrientation.values);
                      },
                      player: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                        topActions: <Widget>[
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              _controller.metadata.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            onPressed: () {
                              // log('Settings Tapped!');
                            },
                          ),
                        ],
                        onReady: () {
                          _isPlayerReady = true;
                        },
                        // onEnded: (data) {
                        //   _controller
                        //       .load([(_ids.indexOf(data.videoId) + 1) % _ids.length]);
                        //   _showSnackBar('Next Video Started!');
                        // },
                      ),
                      builder: (context, player) => player),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // LikeDislikeCompute(post: widget.comps),
                ])));
  }

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        // context.read<CatBloc>().add(
        //     CategoryDelete(cats[idx].id));
        BlocProvider.of<CompBloc>(context)
            .add(CompDelete(widget.comps.id, widget.eventid));
        Navigator.pop(context);

        var snackbar = SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('deleted successfully'),
              Icon(Icons.info),
            ],
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xFF59253A),
        );
        widget.scafoldkey.currentState.showSnackBar(snackbar);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Conformation"),
      content: Text("would you like to delete this issue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _showrequestDialog(context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.6,
            //set this as you want
            maxChildSize: 0.6,
            //set this as you want
            minChildSize: 0.6,
            //set this as you want
            expand: false,
            builder: (context, scrollController) {
              return Container(
                height: 400.0,
                width: 360.0,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "fill judgePoint",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: JudgePoint(
                        id: widget.comps.id,
                        scafoldkey: widget.scafoldkey,
                      ),
                    )
                  ],
                ),
              );
            });
      },
      //isScrollControlled: true,
    );
  }
}
