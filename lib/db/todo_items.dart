import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";

part "todo_items.g.dart";

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  TextColumn get content => text().nullable().named("body")();
  IntColumn get tag => integer().nullable().references(Tags, #id)();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class TodoItemTagsRelationships extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get todoitemId => integer().references(TodoItems, #id)();
  IntColumn get tagId => integer().references(TodoItems, #id)();
}

@DriftDatabase(tables: [TodoItems, Tags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'todo_items');
  }
}
