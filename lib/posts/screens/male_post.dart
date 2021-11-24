import 'package:appp/lib.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MalePost extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafoldkey;
  final String categoryId;

  const MalePost({Key key, this.categoryId, this.scafoldkey}) : super(key: key);
  @override
  _MalePostState createState() => _MalePostState();
}

class _MalePostState extends State<MalePost> {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks

    final postBloc = BlocProvider.of<MaleBloc>(context);
    if (!(postBloc.state is MaleLoadSuccess) ||
        (postBloc.state as MaleLoadSuccess).categoryId != widget.categoryId)
      postBloc.add(MaleLoad(widget.categoryId, "Male"));

    return BlocBuilder<MaleBloc, MaleState>(builder: (context, state) {
      if (state is MaleOperationFailure) {
        return TryAgain();
      }

      if (state is MaleLoadSuccess &&
          (postBloc.state as MaleLoadSuccess).categoryId == widget.categoryId) {
        final posts = state.posts;
        return ListView.builder(
            itemCount: posts.post.length + 1,
            itemBuilder: (_, idx) {
              if (idx == posts.post.length) {
                return GestureDetector(
                  onTap: () {
                    final postBloc = BlocProvider.of<MaleBloc>(context);
                    postBloc.add(MaleLoad(widget.categoryId, "Male"));
                  },
                  child: posts.post.length == 0
                      ? Container(
                          padding: EdgeInsets.all(50.0),
                          child: Center(
                              child: Text("No Record Found  Stay connected!")))
                      : Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Text(
                            "    See More ... ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                );
              }
              return GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserDetail(vedioid: posts.post[idx].video)),
                      ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ProfileImagee(
                                  image:
                                      "${baseURL}/api/${posts.post[idx].photo1}"),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                posts.post[idx].firstName +
                                    "  " +
                                    posts.post[idx].lastName,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Spacer(),
                              IconButton(
                                  icon: Icon(Icons.check_circle_rounded),
                                  onPressed: () {
                                    _showrequestDialog(
                                        context, posts.post[idx].id);
                                  })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 300,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                          ),
                          items: [
                            "$baseURL/api/${posts.post[idx].photo1}",
                            "$baseURL/api/${posts.post[idx].photo2}",
                            "$baseURL/api/${posts.post[idx].photo3}"
                          ]
                              .map((e) => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Image.network(
                                          e,
                                          //Uint8List.fromList(e),
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        // ),
                        SizedBox(
                          height: 10.0,
                        ),
                        LikeDislike(post: posts.post[idx]),
                      ]));
            }
            //)),
            );
      } else {
        return Container(
          child: CircularIndicat(),
        );
      }
    });
  }

  Future _showrequestDialog(context, String uid) {
    return showModalBottomSheet(
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
                        "Send Request",
                        style: TextStyle(
                            fontSize: 21,
                            //color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: SendRequest(
                        userId: uid,
                        scafoldkey: widget.scafoldkey,
                      ),
                    )
                  ],
                ),
              );
            });
      },
      isScrollControlled: true,
    );
  }
}
