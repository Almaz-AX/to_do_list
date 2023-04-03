import 'dart:async' show Future, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/domain/entity/group.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

import '../../navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  var _groups = [];
  late final ValueListenable<Object>? _listenable;

  List get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutesName.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration =
          TaskWidgetConfiguration(group.key as int, group.name);
      unawaited(Navigator.of(context)
          .pushNamed(MainNavigationRoutesName.tasks, arguments: configuration));
    }
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    _readGroupsFromHive();
    _listenable = (await _box).listenable();
    (await _box).listenable().addListener(() => _readGroupsFromHive());
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _listenable?.removeListener(() => _readGroupsFromHive());
    await BoxManager.instance.closeBox(await _box);
    
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
      {super.key, required this.child, required this.model})
      : super(child: child, notifier: model);

  final Widget child;

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
