

import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.category,
    @required this.image,
    @required this.numOfBrands,
    @required this.press,
    this.eventid,
  }) : super(key: key);
  final String eventid;
  final String category;
  final String image;
  final String numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: press,
            child: SizedBox(
              width: getProportionateScreenWidth(270.0),
              height: getProportionateScreenWidth(100.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    SizedBox(
                        child: CachedNetworkImage(
                      width: 280,
                      // height: 100,
                      fit: BoxFit.cover,
                      imageUrl: "${baseURL}/api/${image}",
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    )
                        // Image.memory(
                        //   Uint8List.fromList(image),

                        //   width: 300,
                        //   height: 400,
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF343434).withOpacity(0.4),
                            Color(0xFF343434).withOpacity(0.15),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15.0),
                            vertical: getProportionateScreenWidth(10.0),
                          ),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: "$category\n",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: "$numOfBrands")
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.app_registration),
                            onPressed: () {
                              // ignore: close_sinks
                              final postBloc =
                                  BlocProvider.of<CompBloc>(context);
                              postBloc.add(CompLoad(eventid));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShowComptition(eventid: eventid)));
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpecialOffers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Events",
                style: dropDownMenuItemStyle,
              ),
              Spacer(),
              // Text(
              //   "VIEW ALL",
              // ),
            ],
          ),
        ),
        Container(
          height: 240.0,
          child: _buildCitiesList(context),
        ),
      ],
    );
  }

  Widget _buildCitiesList(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
        // ignore: missing_return
        builder: (context, state) {
      if (state is EventOperationFailure) {
        return TryAgain();
      }

      // if (!(state is EventLoadSuccess)) {
      //   final eventBloc = BlocProvider.of<EventBloc>(context);
      //   eventBloc.add(EventLoad("false"));
      // }

      if (state is EventLoadSuccess) {
        final event = state.events;
        return event.events.isEmpty
            ? Container(
                //padding: EdgeInsets.symmetric(vertical: 150),
                child: Center(
                    child: Text(
                "No Record Found, stay connected!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                maxLines: 2,
              )))
            : ListView.builder(
                itemCount: event.events.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return EventCard(
                    id: event.events[index].id,
                    image: event.events[index].photo,
                    eventname: event.events[index].name,
                    startdate: event.events[index].startDate,
                    enddate: event.events[index].endDate,
                    discription: event.events[index].description,
                  );
                });
      } else {
        return CircularIndicat();
      }
    });
  }
}

class EventCard extends StatelessWidget {
  final String id;
  final String eventname;
  final DateTime startdate;
  final DateTime enddate;
  final String discription;
  final image;

  const EventCard(
      {Key key,
      this.eventname,
      this.startdate,
      this.enddate,
      this.discription,
      this.image,
      this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks

    return Row(children: [
      SpecialOfferCard(
          eventid: id,
          image: image,
          category: eventname,
          numOfBrands: "${formatDate(startdate, [
            yyyy,
            '-',
            mm,
            '-',
            dd
          ])}  -> ${formatDate(enddate, [yyyy, '-', mm, '-', dd])}",
          press: () => {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  isScrollControlled: true,
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
                          return
                              //Container(
                              Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .75,
                                    width: MediaQuery.of(context).size.width,
                                    child: ClipPath(
                                      // clipper: AppClipper(
                                      //   cornerSize: 50,
                                      //   diagonalHeight: 180,
                                      //   roundedBottom: false,
                                      // ),
                                      child: Container(
                                        //color: Colors.white,
                                        padding: EdgeInsets.only(
                                            top: 180, left: 16, right: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ShowRemainigg(id: id),
                                            Container(
                                              width: 300,
                                              child: Text(
                                                eventname,
                                                style: TextStyle(
                                                  fontSize: 32,
                                                ),
                                              ),
                                            ),
                                            Text("${formatDate(startdate, [
                                              yyyy,
                                              '-',
                                              mm,
                                              '-',
                                              dd
                                            ])}  -> ${formatDate(enddate, [
                                              yyyy,
                                              '-',
                                              mm,
                                              '-',
                                              dd
                                            ])}"),
                                            // SizedBox(height: 16),

                                            // //  _buildRating(),
                                            // SizedBox(height: 24),
                                            // Text(
                                            //   "DETAILS",
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.bold,
                                            //     fontSize: 18,
                                            //   ),
                                            // ),
                                            SizedBox(height: 16),
                                            Text(
                                              discription,
                                              style: TextStyle(
                                                  //color: Colors.black38,
                                                  ),
                                            ),
                                            SizedBox(height: 24),

                                            SizedBox(height: 16),
                                            Row(
                                              children: <Widget>[
                                                // _buildColorOption(AppColors.blueColor),
                                                // _buildColorOption(AppColors.greenColor),
                                                // _buildColorOption(AppColors.orangeColor),
                                                // _buildColorOption(AppColors.redColor),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              })
    ]);
  }
}
