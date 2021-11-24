import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WinnersDetail extends StatefulWidget {
  final ComputationPost comps;
  const WinnersDetail({Key key, this.comps}) : super(key: key);

  @override
  _WinnersDetailState createState() => _WinnersDetailState();
}

class _WinnersDetailState extends State<WinnersDetail> {
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
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 20),
        elevation: 4,
        // color: Colors.white70,
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
                        // Text("judgePoint \n ${widget.comps.jugePoints}")
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
                  Text(
                    "judge Point: ${widget.comps.sumOfJugePoints}",
                    style: TextStyle(fontFamily: 'Oxygen'),
                  ),
                  // Text("Number of Like: ${widget.comps.like.length}",
                  //     style: TextStyle(fontFamily: 'Oxygen')),
                  // Text("Number of disLike: ${widget.comps.disLike.length}",
                  //     style: TextStyle(fontFamily: 'Oxygen'))
                ])));
  }


}
