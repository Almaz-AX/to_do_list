import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
        model: _model,
        child: const GroupFormWidgetBody(),);
  }
}

class GroupFormWidgetBody extends StatelessWidget {
  const GroupFormWidgetBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Новая группа'),
        ),
        body: const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _GroupNameWidget()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() => GroupFormWidgetModelProvider.read(context)?.model.saveGroup(context)),
          child: const Icon(Icons.done),
        ),
        );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.watch(context)?.model;
    return  TextField(
      onChanged: (value) => model?.groupName = value,
      onEditingComplete:  () => model?.saveGroup(context),
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Название группы',
        errorText: model?.errorText
      ),
    );
  }
}
