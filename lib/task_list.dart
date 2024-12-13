import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/contexts/app_context.dart';
import 'package:flutter_todo_app/task_item.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    var appContext = Provider.of<AppContext>(context);
    final items = appContext.tasks;

    if (items.isEmpty) {
      return const Center(
        child: Text("あなたは何もしない予定です。"),
      );
    }

    return Consumer<AppContext>(builder: (context, appContext, child) {
      return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return TaskItem(
              item: item,
            );
          });
    });
  }
}
