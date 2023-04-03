import 'package:hive/hive.dart';
import 'package:to_do_list/domain/entity/group.dart';
import 'package:to_do_list/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  BoxManager._();

  Future<Box<Group>> openGroupBox() async {
    return _openBox(1, 'groups_box', GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(2, makeTaskBoxName(groupKey), TaskAdapter());
  }

  String makeTaskBoxName(groupKey) => 'tasks_box_$groupKey';

  Future<void> closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>(
    int typeId,
    String name,
    TypeAdapter<T> adapter,
  ) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
