import 'package:flutter/material.dart';

class TryAgain extends StatelessWidget {
  const TryAgain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 160.0),
          child: Column(
            children: [
              Container(
                child: Text("No internet Connection"),
              ),
              Text("check your connection , then refresh the page"),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child:
                    Text("Refresh", style: TextStyle(color: Colors.lightBlue)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
