import 'package:appp/lib.dart';
import 'package:appp/theme_bloc/theme_bloc.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayNightSwitch extends StatelessWidget {
  const DayNightSwitch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return DayNightSwitcherIcon(
          isDarkModeEnabled: state.themeMode == ThemeMode.dark ? true : false,
          onStateChanged: (state) =>
              BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(state)),
        );
      },
    );
  }
}
