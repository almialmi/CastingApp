import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final catbloc = BlocProvider.of<CatBloc>(context);
    catbloc.add(CategoryLoad());
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.bolt),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeScreenn()));
          },
        ),
      ),
    );
  }
}
