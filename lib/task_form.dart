import 'package:flutter/material.dart';
import 'package:flutter_todo_app/contexts/app_context.dart';
import 'package:flutter_todo_app/db/todo_items.dart';
import 'package:provider/provider.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.onCreated});

  final Function(TodoItem)? onCreated;

  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Title of the todo item
  String _title = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
            top: 16.0, right: 16.0, bottom: 16.0, left: 16.0),
        child: Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                    child: TextFormField(
                  controller: TextEditingController(),
                  decoration: const InputDecoration(labelText: "タスク名"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "タスク名を入力してください。";
                    }
                    if (value.length < 1) {
                      return "タスク名は1文字以上で入力してください。";
                    }
                    if (value.length > 32) {
                      return "タスク名は32文字以内で入力してください。";
                    }
                    return null;
                  },
                  onChanged: (value) => _title = value,
                )),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Consumer<AppContext>(
                        builder: (context, appContext, child) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[500],
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              final createdItem =
                                  await _createItem(appContext, _title);

                              Form.of(context).reset();

                              if (widget.onCreated != null) {
                                widget.onCreated!(createdItem);
                              }
                            }
                          },
                          child: const Text("作成",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)));
                    }))
              ],
            )));
  }

  /// Create a new todo item
  Future<TodoItem> _createItem(AppContext appContext, String title) async {
    var result = await appContext.createItem(title);

    await appContext.syncItems();

    return result;
  }
}
