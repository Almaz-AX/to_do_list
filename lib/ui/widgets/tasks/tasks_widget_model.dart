import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/domain/entity/task.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

import '../../navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier {
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];
  late final ValueListenable<Object>? _listenable;

  List<Task> get tasks => _tasks.toList();

  final TaskWidgetConfiguration configuration;

  TasksWidgetModel({
    required this.configuration,
  }) {
    _setup();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);

    await _readTasks();
    _listenable = (await _box).listenable();
    _listenable?.addListener(() => _readTasks());
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutesName.tasksForm,
        arguments: configuration.groupKey);
  }

  Future<void> _readTasks() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    task?.save();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _listenable?.removeListener(() => _readTasks());
    await BoxManager.instance.closeBox(await _box);
    
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider(
      {super.key, required this.child, required this.model})
      : super(child: child, notifier: model);

  final Widget child;

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
