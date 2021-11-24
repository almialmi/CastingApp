import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class EventBloc extends HydratedBloc<EventEvent, EventState> {
  EventState get initialState {
    return super.state ?? EventLoad("false");
  }

  final EventRepo eventrepository;

  EventBloc({@required this.eventrepository})
      : assert(eventrepository != null),
        super(EventLoading());
  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {
    if (event is EventCreate) {
      try {
        var message =
            await eventrepository.createEvent(event.event, event.image);
        if (message == "Event created successfully!!") {
          final eventt = await eventrepository.getEvents("false");
          yield EventLoadSuccess(eventt);
        } else {
          yield Eventcreationfailed();
        }
      } catch (_) {
        yield EventOperationFailure();
      }
    }
    if (event is EventLoad) {
      yield EventLoading();
      try {
        final events = await eventrepository.getEvents(event.bolean);

        yield EventLoadSuccess(events);
      } catch (e) {
        yield EventOperationFailure();
      }
    }

    if (event is EventUpdate) {
      try {
        await eventrepository.updateEvent(event.event, event.image);
        final eventt = await eventrepository.getEvents("false");
        yield EventLoadSuccess(eventt);
      } catch (e) {
        print(e);
        yield EventOperationFailure();
      }
    }

    if (event is EventUpdatenotPic) {
      try {
        await eventrepository.updateEventNotPic(event.event);
        final eventt = await eventrepository.getEvents("false");
        yield EventLoadSuccess(eventt);
      } catch (e) {
        print(e);
        yield EventOperationFailure();
      }
    }

    if (event is EventDelete) {
      try {
        var message = await eventrepository.deleteEvent(event.event);
        if (message == "Event deleted successfully!") {
          final eventt = await eventrepository.getEvents("false");
          yield EventLoadSuccess(eventt);
        }
      } catch (e) {
        print(e);
        yield EventOperationFailure();
      }
    }

    if (event is ShowRemainig) {
      //yield EventLoading();
      try {
        final events = await eventrepository.showRemaining(event.id);
        yield Showremainingsuccess(events);
        // final eventt = await eventrepository.getEvents("false");
        // yield EventLoadSuccess(eventt);

      } catch (e) {
        print(e);
        yield EventOperationFailure();
      }
    }
  }

  @override
  EventState fromJson(Map<String, dynamic> json) {
    try {
      final event = Event.fromJson(json);
      if (event == null) {
        return EventOperationFailure();
      }
      event.events.removeWhere((element) => element == null);
      if (event.events.length == 0) return EventOperationFailure();
      return EventLoadSuccess(event);
    } catch (e, a) {
      return EventOperationFailure();
    }
  }

  @override
  Map<String, dynamic> toJson(EventState state) {
    try {
      if (state is EventLoadSuccess) {
        if (state.events == null) {
          return null;
        }
        return state.events.toJson();
      }
    } catch (e, a) {
      return null;
    }
    return null;
  }
}
