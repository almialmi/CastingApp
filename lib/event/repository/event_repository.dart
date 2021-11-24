import 'dart:io';
import 'package:appp/lib.dart';

class EventRepo {
  

  EventProvider eventProvider;

  EventRepo() : assert(EventProvider != null) {
    EventProvider.getInstance().then((value) {
      this.eventProvider = value;
    });
  }

  Future<String> createEvent(EventElement event, File file) async {
    return await eventProvider.createEvent(event, file);
  }

  Future<Event> getEvents(String booleann) async {
    return await eventProvider.getevents(booleann);
  }

  Future<Show> showRemaining(String id) async {
    return await eventProvider.showRemainingTime(id);
  }

  Future<String> deleteEvent(String id) async {
    return await eventProvider.deleteEvent(id);
  }

  Future<String> updateEvent(EventElement element, File file) async {
    return await eventProvider.updateEvent(element, file);
  }

  Future<void> updateEventNotPic(EventElement element) async {
    return await eventProvider.updateEventNotpic(element);
  }
}
