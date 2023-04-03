import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isDone;

  Task({
    required this.name,
    required this.isDone,
    });
}
