import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/tasks_form/tasks_form_widget_model.dart';

class TasksFormWidget extends StatefulWidget {
  final int groupKey;
  const TasksFormWidget({super.key, required this.groupKey});

  @override
  State<TasksFormWidget> createState() => _TasksFormWidgetState();
}

class _TasksFormWidgetState extends State<TasksFormWidget> {
  late final TasksFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TasksFormWidgetModelProvider(
        child: const TasksFormWidgetBody(), model: _model);
  }
}

class TasksFormWidgetBody extends StatelessWidget {
  const TasksFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksFormWidgetModelProvider.watch(context)?.model;
    final actionButton1 = FloatingActionButton(
      onPressed: () => model?.saveTask(context),
      child: const Icon(Icons.done),
    );
    const actionButton2 = FloatingActionButton(
      onPressed: null,
      backgroundColor: Colors.grey,
      child: Icon(Icons.done),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая задача'),
      ),
      body: const Center(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _TasksNameWidget()),
      ),
      floatingActionButton: model?.isValid == true? actionButton1 : actionButton2,
    );
  }
}

class _TasksNameWidget extends StatelessWidget {
  const _TasksNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksFormWidgetModelProvider.read(context)?.model;
    return TextField(
      onChanged: (value) => model?.taskName = value,
      onEditingComplete: () => model?.saveTask(context),
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Название задачи',
      ),
    );
  }
}
