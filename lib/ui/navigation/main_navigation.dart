import 'package:flutter/material.dart';

import '../widgets/group_form/group_form_widget.dart';
import '../widgets/groups/groups_widget.dart';
import '../widgets/tasks/tasks_widget.dart';
import '../widgets/tasks_form/tasks_form_widget.dart';

abstract class MainNavigationRoutesName {
  static const String groups = '/';
  static const String groupsForm = '/groupsForm';
  static const String tasks = '/tasks';
  static const String tasksForm = '/tasks/form';
}

class MainNavigation {
  final String initialRoute = MainNavigationRoutesName.groups;

  final Map<String, Widget Function(BuildContext)> routes = {
    MainNavigationRoutesName.groups: (context) => const GroupsWidget(),
    MainNavigationRoutesName.groupsForm: (context) => const GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutesName.tasks:
        final configuration = settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(
            builder: (context) => TasksWidget(
                  configuration: configuration,
                ));
      case MainNavigationRoutesName.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => TasksFormWidget(
                  groupKey: groupKey,
                ));

      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
