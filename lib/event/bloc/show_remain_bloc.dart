import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowBloc extends Bloc<EventEvent, EventState> {
  

final EventRepo eventrepository;

  ShowBloc({@required this.eventrepository})
      : assert(eventrepository != null),
        super(EventLoading());
  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {

    if (event is ShowRemainig) {
      //yield EventLoading();
      try {
       final events = await eventrepository.showRemaining(event.id);
        yield Showremainingsuccess(events);
      } catch (e) {
        print(e);
        yield EventOperationFailure();
      }
    }

   
   
  }
}
