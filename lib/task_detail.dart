import 'package:flutter/material.dart';
import 'package:flutter_todo_app/db/todo_items.dart';

class TaskDetail extends StatelessWidget {
  const TaskDetail({super.key, required this.item});

  final TodoItem item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(item.title)),
            body: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.content ?? "<No Content>"),
                      const SizedBox(height: 16),
                      Text("Created: ${item.createdAt}"),
                      const SizedBox(height: 8),
                      Text("Updated: ${item.updatedAt}"),
                    ]))));
  }
}
