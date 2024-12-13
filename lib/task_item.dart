import 'package:flutter/material.dart';
import 'package:flutter_todo_app/contexts/app_context.dart';
import 'package:flutter_todo_app/db/todo_items.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatelessWidget {
  final TodoItem item;

  const TaskItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final appContext = Provider.of<AppContext>(context, listen: false);

    final iconData =
        item.completed ? Icons.check_box : Icons.check_box_outline_blank;

    const datesStyle = TextStyle(fontSize: 11.0, color: Colors.black54);

    var createdAtDate = "${item.createdAt.year}"
        "-${item.createdAt.month.toString().padLeft(2, "0")}"
        "-${item.createdAt.day.toString().padLeft(2, "0")}";

    var createdAtTime = "${item.createdAt.hour.toString().padLeft(2, "0")}"
        ":${item.createdAt.minute.toString().padLeft(2, "0")}"
        ":${item.createdAt.second.toString().padLeft(2, "0")}";

    var updatedAtDate = "${item.updatedAt.year}"
        "-${item.updatedAt.month.toString().padLeft(2, "0")}"
        "-${item.updatedAt.day.toString().padLeft(2, "0")}";

    var updatedAtTime = "${item.updatedAt.hour.toString().padLeft(2, "0")}"
        ":${item.updatedAt.minute.toString().padLeft(2, "0")}"
        ":${item.updatedAt.second.toString().padLeft(2, "0")}";

    List<Widget> taskData = [];

    if (item.content != null && item.content!.isNotEmpty) {
      taskData.addAll([
        const SizedBox(width: 8),
        // Container(
        // padding: const EdgeInsets.only(top: 10, bottom: 10),
        // child: Text(item.content!),
        // ),
        Text(item.content!),
        const SizedBox(width: 8),
      ]);
    }

    taskData.addAll([
      Text(
        "Created: $createdAtDate $createdAtTime",
        style: datesStyle,
      ),
      const SizedBox(width: 8),
      Text(
        "Updated: $updatedAtDate $updatedAtTime",
        style: datesStyle,
      )
    ]);

    return ListTile(
      title: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed("/task_detail", arguments: item),
        child: Text(item.title),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: taskData,
      ),
      trailing: IconButton(
        icon: Icon(iconData),
        onPressed: () async {
          if (item.completed) {
            await appContext.uncomplete(item);
          } else {
            await appContext.complete(item);
          }

          appContext.syncItems();
        },
      ),
    );
  }

  void _navigateToTaskDetail(BuildContext context) {
    Navigator.of(context).pushNamed("/task-detail", arguments: item);
  }
}
