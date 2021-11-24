import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: ShowCategory(),
          icon: Icon(Icons.home),
          title: "Show Category",
        ),
        TabNavigationItem(
          page: CreateCategory(),
          icon: Icon(Icons.create),
          title: "Create Category",
        ),
      ];
}
