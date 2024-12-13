import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/contexts/app_context.dart';
import 'package:flutter_todo_app/task_item.dart';
import 'package:provider/provider.dart';

class CompletedList extends StatelessWidget {
  const CompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    var appContext = Provider.of<AppContext>(context);
    final items = appContext.completedTasks;

    if (items.isEmpty) {
      return const Center(
        child: Text("あなたはまだ何もしていません。"),
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
