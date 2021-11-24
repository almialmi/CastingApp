import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JudgePoint extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafoldkey;
  final String id;

  const JudgePoint({Key key, this.id, this.scafoldkey}) : super(key: key);
  @override
  _JudgePointState createState() => _JudgePointState();
}

class _JudgePointState extends State<JudgePoint> {
  final Map<String, dynamic> _request = {};
  String inputval = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        icon: Icon(Icons.format_list_numbered),
                        hintText: 'enter point',
                        labelText: 'judge_point *',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please insert your point';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        this._request['judgePoint'] = int.parse(val);
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          DefaultButton(
            text: "Submit",
            press: () async {
              if (_formKey.currentState.validate()) {
                final CompEvent event =
                    UpdateJudgePoint(widget.id, this._request['judgePoint']);

                BlocProvider.of<CompBloc>(context).add(event);
                Navigator.pop(context);
                var snackbar = SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('set successfully'),
                      Icon(Icons.info),
                    ],
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Theme.of(context).shadowColor,
                );
                widget.scafoldkey.currentState.showSnackBar(snackbar);
              }
            },
          ),
        ],
      ),
    );
  }
}
