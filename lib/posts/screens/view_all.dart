import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAll extends StatefulWidget {
  const ViewAll({Key key}) : super(key: key);

  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
        appBar: MyAppBar.buildAppbar(context, "categories"),
        body: BlocBuilder<CatBloc, CatState>(builder: (context, state) {
          if (state is CategoryOperationFailure) {
            return TryAgain();
          }
          if (state is CategoryLoadSuccess) {
            print("misa libela new ${itemWidth / itemHeight} ");
            final catgs = state.cats;
            return GridView.count(
                childAspectRatio: 1.6 / 2,
                shrinkWrap: false,
                crossAxisCount: 2,
                children: List.generate(catgs.length, (index) {
                  return Center(
                    child: _buildImageCard(catgs[index]),
                  );
                }));
          } else {
            return CircularIndicat();
          }
        }));
    // ],
    // ),
    // ),
    //);
  }

  Widget _buildImageCard(Category choice) {
    return CityCard(
        imgAssetPath: choice.photo, name: choice.name, press: () {});
  }
}
