import 'package:flutter/material.dart';

import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var _groupName = '';
  var errorText = null;

  String get groupName => _groupName;
  set groupName(String value) {
    if (value.trim().isNotEmpty && errorText != null) {
      errorText = null;
      notifyListeners();
    }
    _groupName = value.trim();
  }

  void saveGroup(BuildContext context) async {
    if (_groupName.isEmpty) {
      errorText = 'Не указано название группы';
      notifyListeners();
      return;
    } else
      errorText = null;
    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    await box.add(group);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;
  const GroupFormWidgetModelProvider(
      {super.key, required this.model, required this.child})
      : super(child: child, notifier: model);

  final Widget child;

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return true;
  }
}
