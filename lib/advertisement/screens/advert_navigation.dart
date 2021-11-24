import 'package:appp/advertisement/screens/show_adverts.dart';
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
          page: ShowAdvert(),
          icon: Icon(Icons.home),
          title: "Show Adverts",
        ),
        TabNavigationItem(
          page: CreateAdvert(),
          icon: Icon(Icons.create),
          title: "Create Adverts",
        ),
      ];
}
