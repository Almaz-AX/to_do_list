import 'package:flutter/material.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import '../../../domain/entity/task.dart';

class TasksFormWidgetModel extends ChangeNotifier {
  int groupKey;
  var _taskName = '';
  

  TasksFormWidgetModel({required this.groupKey});

  set taskName(String value) {
    final isTaskNameIsEmpty = _taskName.trim().isEmpty;
    _taskName = value.trim();
    if (value.trim().isEmpty != isTaskNameIsEmpty) {
      notifyListeners();
    };
  }
  bool get isValid => _taskName.trim().isNotEmpty;
  String get taskName => _taskName.toString();

  void saveTask(BuildContext context) async {
    if (_taskName.isEmpty) return;

    final task = Task(name: taskName, isDone: false);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    Navigator.of(context).pop();
  }
}

class TasksFormWidgetModelProvider extends InheritedNotifier {
  final TasksFormWidgetModel model;
  const TasksFormWidgetModelProvider(
      {super.key, required this.child, required this.model})
      : super(
          child: child,
          notifier: model,
        );

  final Widget child;

  static TasksFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksFormWidgetModelProvider>();
  }

  static TasksFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksFormWidgetModelProvider>()
        ?.widget;
    return widget is TasksFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TasksFormWidgetModelProvider oldWidget) {
    return true;
  }
}
