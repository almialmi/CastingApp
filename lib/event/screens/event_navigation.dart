import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  EventNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<EventNavigationItem> get items => [
        EventNavigationItem(
          page: ShowEvent(),
          icon: Icon(Icons.home),
          title: "Show Events",
        ),
        EventNavigationItem(
          page: CreateEvent(),
          icon: Icon(Icons.create),
          title: "Create Event",
        ),
      ];
}
