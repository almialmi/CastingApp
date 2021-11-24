import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowRemainigg extends StatelessWidget {
  final String id;
  const ShowRemainigg({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final showBloc = BlocProvider.of<ShowBloc>(context);
    showBloc.add(ShowRemainig(id));
    return BlocBuilder<ShowBloc, EventState>(
      builder: (context, state) {
        if (state is EventOperationFailure) {
          return Text(
            "please check your internet connection",
            style: TextStyle(color: Colors.blue),
          );
        }
        if (state is Showremainingsuccess) {
          print("ewaa + ${state.message.message}");
          final event = state.message.message;
          return Text(
            event,
            style: TextStyle(color: Colors.red),
          );
        } else {
          return Text("Loading");
        }
      },
    );
  }
}
