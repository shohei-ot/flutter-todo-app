import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todo_app/db/todo_items.dart';

class AppContext extends ChangeNotifier {
  AppContext({required this.db});

  final AppDatabase db;

  final List<TodoItem> _items = [];
  List<TodoItem> get items => _items;

  List<TodoItem> _tasks = [];
  List<TodoItem> get tasks => _tasks;

  List<TodoItem> _completedTasks = [];
  List<TodoItem> get completedTasks => _completedTasks;

  bool _initialized = false;
  bool get initialized => _initialized;

  bool _progress = false;
  bool get progress => _progress;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    await syncItems(initialization: true);
    _initialized = true;
  }

  Future<void> syncItems({bool initialization = false}) async {
    _progress = true;
    if (!initialization) {
      notifyListeners();
    }

    await Future.wait([
      _retrieveItems(completed: false),
      _retrieveItems(completed: true),
    ]).then((value) {
      _tasks = value[0];
      _completedTasks = value[1];
    });

    _progress = false;

    if (!initialization) {
      notifyListeners();
    }
  }

  ///
  /// Get a todo item by id
  ///
  Future<TodoItem> retrieveItem(int rowId) async {
    var item = await (db.select(db.todoItems)..where((t) => t.id.equals(rowId)))
        .getSingle();

    return item;
  }

  ///
  /// Create a todo item
  ///
  Future<TodoItem> createItem(String title, {String? content}) async {
    var item = TodoItemsCompanion.insert(
        title: title,
        content: Value(content),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    var rowId = await db.todoItems.insertOne(item);

    var createdItem = await (db.select(db.todoItems)
          ..where((t) => t.id.equals(rowId)))
        .getSingle();

    return createdItem;
  }

  ///
  /// Get all todo items
  ///
  Future<List<TodoItem>> _retrieveItems({bool completed = false}) async {
    return (db.select(db.todoItems)
          ..where((t) => t.completed.equals(completed))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  ///
  /// Complete a todo item
  ///
  Future<void> complete(TodoItem item) async {
    var updateItem = item.copyWith(completed: true, updatedAt: DateTime.now());

    var ok = await db.todoItems.update().replace(updateItem);

    if (!ok) {
      throw Exception("Failed to update item");
    }

    return;
  }

  ///
  /// Uncomplete a todo item
  ///
  Future<void> uncomplete(TodoItem item) async {
    var updateItem = item.copyWith(completed: false, updatedAt: DateTime.now());

    var ok = await db.todoItems.update().replace(updateItem);

    if (!ok) {
      throw Exception("Failed to update item");
    }

    await syncItems();

    return;
  }

  Future<void> truncate() async {
    await db.todoItems.deleteAll();
    await syncItems();
  }

  /// Update a todo item
  Future<TodoItem> _updateItem(TodoItem item,
      {String? title, String? content, bool? completed}) async {
    var updateItem = item.copyWith(
        title: title ?? item.title,
        content: Value(content ?? item.content),
        completed: completed ?? item.completed,
        updatedAt: DateTime.now());

    var ok = await db.todoItems.update().replace(updateItem);

    if (!ok) {
      throw Exception("Failed to update item");
    }

    return updateItem;
  }

  /// Delete a todo item
  Future<void> _deleteItem(TodoItem item) async {
    var ok = await db.todoItems.deleteOne(item);

    if (!ok) {
      throw Exception("Failed to delete item");
    }

    return;
  }
}
