import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  UserNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<UserNavigationItem> get items => [
        UserNavigationItem(
          page: ShowUsers(),
          icon: Icon(Icons.home),
          title: "Show Users",
        ),
        UserNavigationItem(
          page: CreateUsers(),
          icon: Icon(Icons.create),
          title: "Create  Users",
        ),
      ];
}
