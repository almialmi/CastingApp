import 'package:appp/lib.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendRequest extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafoldkey;
  final String userId;

  const SendRequest({Key key, this.userId, this.scafoldkey}) : super(key: key);
  @override
  _SendRequestState createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  DateTime selectedDate = DateTime.now();
  TextEditingController dateCtl = TextEditingController();
  //String applyerId;
  final Map<String, dynamic> _request = {};
  String inputval = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // SharedPrefUtils.getidvalue().then((appId) {
    //   setState(() {
    //     applyerId = appId;
    //   });
    //print("applyer is: $applyerId");
    //});
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
                      maxLines: 2,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        hintText: 'discreption about the user?',
                        labelText: 'description *',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please insert description';
                        }
                        return null;
                        // double advancePayment = double.parse(val);
                        // if (widget.pay > widget.order.totalPrice) {
                        //   return "payment can not be grater than total price";
                        // }
                        // if (widget.order.totalPrice - widget.pay < 0) {
                        //   return "wrong operation";
                        // }
                        // return null;
                      },
                      onChanged: (val) {
                        this._request['description'] = val;
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                      // keyboardType: TextInputType.number,
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.digitsOnly
                      // ],
                      decoration: const InputDecoration(
                        icon: Icon(Icons.format_list_numbered),
                        hintText: 'enter duration',
                        labelText: 'duration *',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please insert duration';
                        }
                        return null;
                        // double advancePayment = double.parse(val);
                        // if (widget.pay > widget.order.totalPrice) {
                        //   return "payment can not be grater than total price";
                        // }
                        // if (widget.order.totalPrice - widget.pay < 0) {
                        //   return "wrong operation";
                        // }
                        // return null;
                      },
                      onChanged: (val) {
                        this._request['duration'] = val;
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    // initialValue:
                    //  widget.eventstartdate.toString(),
                    controller: dateCtl,
                    decoration: InputDecoration(
                      icon: Icon(Icons.date_range),
                      //border: OutlineInputBorder(),
                      labelText: "start date",
                      hintText: "dd-mm-yyyy",
                    ),
                    onTap: () async {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      dateCtl.text =
                          "${formatDate(date, [yyyy, '-', mm, '-', dd])}";

                      setState(() {
                        selectedDate = date.toLocal();
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter startDate';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        this._request['dateForWork'] = selectedDate,

                    // double.parse(value),
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
                print("date for work for create requesst is ${selectedDate}");
                final RequestEvent event = RequestCreate(
                  RequestElement(
                      description: this._request['description'],
                      duration: this._request['duration'],
                      dateForWork: selectedDate,
                      applyerid: MyID,
                      requestedUserId: widget.userId),
                );

                BlocProvider.of<RequestBloc>(context).add(event);
                // Scaffold.of(context)
                //   .showSnackBar(SnackBar(content: Text('Sending request..')));
                Navigator.pop(context);

                var snackbar = SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('request sent successfully'),
                      Icon(Icons.info),
                    ],
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Theme.of(context).shadowColor,
                );
                widget.scafoldkey.currentState.showSnackBar(snackbar);

                //      Navigator.pushReplacement(
                // context,
                // MaterialPageRoute(
                //   builder: (context) => ShowUsers(),
                // ),
                // );
                //   advancePayment.AdvancePayment advancepay =
                //       new advancePayment.AdvancePayment();
                //   advancepay.price = double.parse(inputval);

                //   await advancepay.save(orderId: widget.order.id);

                //   Navigator.pop(context, double.parse(inputval));
              }
            },
          ),
        ],
      ),
    );
  }
}
