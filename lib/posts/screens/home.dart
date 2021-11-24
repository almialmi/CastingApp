import 'dart:typed_data';
import 'package:appp/advertisement/screens/advert_home.dart';
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_shape_clippert.dart';
import 'package:cached_network_image/cached_network_image.dart';

Color firstColor = Color(0xFFF47D15);
Color secondColor = Color(0xFFEF772C);

ThemeData appTheme =
    ThemeData(primaryColor: Color(0xFFF3791A), fontFamily: 'Oxygen');

class HomeScreenn extends StatefulWidget {
  final UserRepository _userRepository;

  const HomeScreenn({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
  @override
  HomeScreennState createState() {
    return new HomeScreennState();
  }
}

class HomeScreennState extends State<HomeScreenn> {
  @override
  Widget build(BuildContext context) {
    final ideaBloc = BlocProvider.of<CatBloc>(context);
    if (ideaBloc != null && !(ideaBloc.state is CategoryLoadSuccess))
      ideaBloc.add(CategoryLoad());

    final eventBloc = BlocProvider.of<EventBloc>(context);
    if (eventBloc != null && !(eventBloc.state is EventLoadSuccess))
      eventBloc.add(EventLoad("false"));

    final advertBloc = BlocProvider.of<AdvertBloc>(context);
    if (advertBloc != null && !(advertBloc.state is AdvertLoadSuccess))
      advertBloc.add(AdvertLoad("Active"));
    final userBloc = BlocProvider.of<UserBloc>(context);
    if (!(userBloc.state is UserLoadSuccess)) userBloc.add(UserLoad());

    return Scaffold(
      drawer: CustomDrawer(),
      // bottomNavigationBar: CustomAppBottomBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            HomeScreenTopPart(),

            NoticeBoard(),

            // HomeScreenBottomPart(),
            HomeScreenBottomPart(),
            SpecialOffers(),
          ],
        ),
      ),
    );
  }
}

const TextStyle dropDownLabelStyle =
    TextStyle(color: Colors.white, fontSize: 16.0);
const TextStyle dropDownMenuItemStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 300.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).indicatorColor,
                  Theme.of(context).disabledColor
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu),

                      onPressed: () => Scaffold.of(context).openDrawer(),
                      color: Colors.white,

                      //Icons.menu,
                    ),
                    // Spacer(),
                    //DayNightSwitch(),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                  'Where would you\nlike to go?',
                  style: TextStyle(
                    fontFamily: 'Oxygen',
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        // appBloc.addToLocation.add(text);
                      },
                      style: dropDownMenuItemStyle,
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 14.0),
                        suffixIcon: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Scaffold.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'comming soon!',
                                          style:
                                              TextStyle(fontFamily: 'Oxygen'),
                                        ),
                                        Icon(Icons.error),
                                      ],
                                    ),
                                    duration: Duration(seconds: 1),
                                    backgroundColor:
                                        Theme.of(context).shadowColor,
                                  ),
                                );
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ChoiceChip extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  ChoiceChip(this.icon, this.text, this.isSelected);

  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20.0,
            color: Colors.white,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }
}

class HomeScreenBottomPart extends StatefulWidget {
  @override
  HomeScreenBottomPartState createState() {
    return new HomeScreenBottomPartState();
  }
}

class HomeScreenBottomPartState extends State<HomeScreenBottomPart> {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Categories",
                style: dropDownMenuItemStyle,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewAll()));
                },
                child: Column(
                  children: [
                    Text(
                      "VIEW ALL",
                      //style: dropDownMenuItemStyle,
                    ),
                    //Icon(Icons.)
                  ],
                ),
              ),
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
}

Widget _buildCitiesList(BuildContext context) {
  return BlocBuilder<CatBloc, CatState>(
      // ignore: missing_return
      builder: (context, state) {
    if (state is CategoryOperationFailure) {
      return TryAgain();
    }
    if (state is CategoryLoadSuccess) {
      final catgs = state.cats;

      return catgs.isEmpty
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 150),
              child: Center(
                  child: Text(
                "No Record Found, stay connected!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                maxLines: 2,
              )))
          : ListView.builder(
              itemCount: catgs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == catgs.length) {
                  return Container(
                      padding: EdgeInsets.all(50.0),
                      child: Center(
                          child: Text(
                        "No Record Found, stay connected!",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        maxLines: 2,
                      )));
                  //return Center(child: Text("got no idea"));
                }
                return CityCard(
                    imgAssetPath: catgs[index].photo,
                    name: catgs[index].name,
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserFemaleMale(categoryId: catgs[index].id)));
                      //print("silenat is here: ${catgs[index].photo.data.data}");
                    });
              });
    } else {
      return CircularIndicat();
      //Container(child: Text("Loading........"));
    }
  });
}

class CityCard extends StatelessWidget {
  final String imgAssetPath;
  final String name;
  final GestureTapCallback press;

  const CityCard({Key key, this.imgAssetPath, this.name, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: press,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 210.0,
                    width: 160.0,
                    child: CachedNetworkImage(
                      imageUrl: "${baseURL}/api/${imgAssetPath}",
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 160.0,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black,
                            Colors.black.withOpacity(0.1),
                          ])),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Image> assetThumbToImage(asset) async {
    final ByteData byteData = await asset.getByteData();

    final Image image = Image.memory(byteData.buffer.asUint8List());

    return image;
  }
}
