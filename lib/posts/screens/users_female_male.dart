import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFemaleMale extends StatefulWidget {
  final String categoryId;

  const UserFemaleMale({Key key, this.categoryId}) : super(key: key);
  @override
  _UserFemaleMaleState createState() => _UserFemaleMaleState();
}

class _UserFemaleMaleState extends State<UserFemaleMale> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String url;
  // VideoPlayerController _controller;
  VoidCallback listner;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    listner = () {
      setState(() {});
    };
  }

  setIndex(int intdex) {
    setState(() {
      this.selectedIndex = intdex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            tabs: [
              Tab(icon: Icon(Icons.pregnant_woman), text: ("Female")),
              Tab(
                icon: Icon(Icons.person),
                text: ("Male"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FemalePost(categoryId: widget.categoryId, scafoldkey: _scaffoldKey),
            MalePost(categoryId: widget.categoryId, scafoldkey: _scaffoldKey),
          ],
        ),
      ),
    );
  }

  buildPage(String gender) {
    // ignore: close_sinks
    final postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(PostLoad(widget.categoryId, gender));
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state is PostOperationFailure) {
        return Text('Could not do post operation');
      }

      if (state is PostLoadSuccess) {
        // print("ere love");
        final posts = state.posts;
        return ListView.builder(
          itemCount: posts.post.length,
          itemBuilder: (_, idx) => GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserDetail(vedioid: posts.post[idx].video)),
                  ),
              child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            // Container(
                            //   child: IconButton(
                            //     icon: Icon(Icons.more_horiz),
                            //     onPressed: () {
                            //       showDialog(
                            //         context: context,
                            //         builder: (BuildContext context) =>

                            // },
                            // )             //             _buildPopupDialog(context),
                            //       );
                            //     },
                            //   ),
                            //   margin: const EdgeInsets.symmetric(horizontal: 300.0),
                            // ),
                            Container(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        AssetImage("assets/images/model.jpg"),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    posts.post[idx].firstName +
                                        "  " +
                                        posts.post[idx].lastName,
                                    // posts[idx].post[idx].firstName + posts[idx].post[idx].lastName,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              child:
                                  //  AspectRatio(
                                  //   aspectRatio: 16 / 9,
                                  //   child: Container(
                                  //       child: _controller != null
                                  //           ? VideoPlayer(_controller)
                                  //           : Container()),
                                  // ),

                                  //child: VideoPlayer(_controller),
                                  //  ),
                                  //: Container(),

                                  Image.asset(
                                "assets/images/model.jpg",
                                height: 150,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {}),
                                Text("12k"),
                                SizedBox(
                                  width: 10.0,
                                ),
                                IconButton(
                                    icon: Icon(Icons.thumb_down_sharp),
                                    onPressed: () {}),
                                Text("1k")
                              ],
                            )
                          ])))),
        );
      } else {
        return Container(
          child: Text("loading"),
        );
      }
    });
  }
}
