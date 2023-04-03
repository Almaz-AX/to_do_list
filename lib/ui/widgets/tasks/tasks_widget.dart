import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskWidgetConfiguration {
  final int groupKey;
  final String title;
  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;
  const TasksWidget({super.key, required this.configuration});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;
  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _model.dispose();
    
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.configuration.title ?? 'Задачи';
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const _TasksListWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model?.showForm(context),
          child: const Icon(Icons.add),
        ));
  }
}

class _TasksListWidget extends StatelessWidget {
  const _TasksListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final taskCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
        itemBuilder: (context, index) {
          return TaskRowWidget(
            indexInList: index,
          );
        },
        separatorBuilder: ((context, index) {
          return const Divider(height: 1);
        }),
        itemCount: taskCount);
  }
}

class TaskRowWidget extends StatelessWidget {
  final int indexInList;
  const TaskRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];
    final icon = task.isDone ? Icons.done : null;
    final style = task.isDone
        ? const TextStyle(
            decoration: TextDecoration.lineThrough,
          )
        : null;
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.name,
          style: style,
        ),
        trailing: Icon(icon),
        onTap: () => model.doneToggle(indexInList),
      ),
    );
  }
}
