import 'package:flutter/material.dart';
import 'package:flutter_todo_app/completed_list.dart';
import 'package:flutter_todo_app/contexts/app_context.dart';
import 'package:flutter_todo_app/db/todo_items.dart';
import 'package:flutter_todo_app/task_detail.dart';
import 'package:flutter_todo_app/task_form.dart';
import 'package:flutter_todo_app/task_list.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppContext appContext = AppContext(db: AppDatabase());

  runApp(ChangeNotifierProvider.value(
      value: appContext,
      child: MaterialApp(
        home: MyApp(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case "/task_detail":
              if (settings.arguments is TodoItem) {
                var item = settings.arguments as TodoItem;
                return MaterialPageRoute(
                    builder: (context) => TaskDetail(item: item));
              } else {
                throw Exception("Unexpected type of arguments");
              }
          }

          return null;
        },
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Future<bool>? _initialized;

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: TaskList()),
    Center(child: CompletedList()),
    Text("Index 2: Settings", style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _initialized = initContextData();
    super.initState();
  }

  Future<bool> initContextData() async {
    await context.read<AppContext>().init();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final isMainView = _selectedIndex == 0;

    return SafeArea(
        child: FutureBuilder(
            future: _initialized,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  // appBar: AppBar(),
                  body: _widgetOptions.elementAt(_selectedIndex),
                  bottomNavigationBar: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(Icons.list), label: "Tasks"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.check), label: "Completed"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: "Settings"),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Colors.amber[800],
                      onTap: _onItemTapped),
                  floatingActionButton: isMainView
                      ? IconButton.filled(
                          onPressed: () {
                            showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: TaskForm(
                                      onCreated: (item) {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 36.0,
                          ))
                      : null,
                );
              }

              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }));
  }
}
