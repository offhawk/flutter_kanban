import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban/components/my_card.dart';
import 'package:kanban/components/my_text_field.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Task> _taskList = [];

  int? taskId = 0;
  List<Task> tasks = [];

  void updateList(Task task, int newIndex) {
    setState(() {
      _taskList.removeWhere((item) => item.id == task.id);
      _taskList = [
        ..._taskList,
        Task(desc: task.desc, type: newIndex, id: task.id)
      ];
    });
    saveList();
  }

  void addList(Task task) {
    setState(() {
      taskId = _taskList.isNotEmpty ? _taskList[_taskList.length - 1].id! + 1 : 0;
      print(taskId);
      _taskList = [
        ..._taskList,
        Task(desc: task.desc, type: task.type, id: taskId)
      ];
    });
    saveList();
  }

  void removeList(Task task) {
    setState(() {
      _taskList.removeWhere((item) => item.id == task.id);
    });
    saveList();
  }

  void saveList() async{
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Task.encode(_taskList.toList());
    await prefs.setString('tasks_key', encodedData);
  }

  void getList() async{
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = await prefs.getString('tasks_key');
    tasks = Task.decode(tasksString!);
    _taskList = tasks;
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    getList();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xfff1f2f7),
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Meu Quadro',
              style: GoogleFonts.bricolageGrotesque(
                  color: const Color(0xff2c303f),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 40),
            Expanded(
              child: SizedBox(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    DropRegion(
                      formats: Formats.standardFormats,
                      hitTestBehavior: HitTestBehavior.opaque,
                      onDropOver: (event) {
                        final item = event.session.items.first;

                        if (event.session.allowedOperations
                            .contains(DropOperation.copy)) {
                          return DropOperation.copy;
                        } else {
                          return DropOperation.none;
                        }
                      },
                      onPerformDrop: (event) async {
                        final item = event.session.items.first;
                        final data = item.localData;
                        if (data is Map) {
                          updateList(
                              Task(
                                  desc: data['desc'],
                                  type: data['type'],
                                  id: data['id']),
                              0);
                        }
                        ;
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Row(
                                children: [
                                  Stack(children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      top: 9,
                                      left: 9,
                                      child: Image.asset(
                                        'lib/images/box.png',
                                        width: 24,
                                      ),
                                    ),
                                  ]),
                                  SizedBox(width: 10),
                                  Container(
                                      child: Text(
                                    'A Fazer',
                                    style: GoogleFonts.bricolageGrotesque(
                                        color: const Color(0xff2c303f),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ],
                              ),
                              const SizedBox(height: 20),
                              ListView.builder(
                                itemCount: _taskList
                                    .where((tsk) => tsk.type == 0)
                                    .toList()
                                    .length,
                                shrinkWrap: true,
                                key: GlobalKey(),
                                itemBuilder: (context, index) {
                                  final item = _taskList
                                      .where((tsk) => tsk.type == 0)
                                      .toList()[index];
                                  if (item.type == 0) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: MyCard(
                                          task: item,
                                          parentRemoveList: removeList),
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              MyTextField(parentAddList: addList, type: 0),
                            ]),
                          )),
                    ),
                    const SizedBox(width: 20),
                    DropRegion(
                      formats: Formats.standardFormats,
                      hitTestBehavior: HitTestBehavior.opaque,
                      onDropOver: (event) {
                        final item = event.session.items.first;

                        if (event.session.allowedOperations
                            .contains(DropOperation.copy)) {
                          return DropOperation.copy;
                        } else {
                          return DropOperation.none;
                        }
                      },
                      onPerformDrop: (event) async {
                        final item = event.session.items.first;
                        final data = item.localData;
                        if (data is Map) {
                          updateList(
                              Task(
                                  desc: data['desc'],
                                  type: data['type'],
                                  id: data['id']),
                              1);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Row(
                                children: [
                                  Stack(children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      top: 9,
                                      left: 9,
                                      child: Image.asset(
                                        'lib/images/tool.png',
                                        width: 24,
                                      ),
                                    ),
                                  ]),
                                  SizedBox(width: 10),
                                  Container(
                                      child: Text(
                                    'Em Andamento',
                                    style: GoogleFonts.bricolageGrotesque(
                                        color: const Color(0xff2c303f),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ],
                              ),
                              const SizedBox(height: 20),
                              ListView.builder(
                                itemCount: _taskList
                                    .where((tsk) => tsk.type == 1)
                                    .toList()
                                    .length,
                                shrinkWrap: true,
                                key: GlobalKey(),
                                itemBuilder: (context, index) {
                                  final item = _taskList
                                      .where((tsk) => tsk.type == 1)
                                      .toList()[index];
                                  if (item.type == 1) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: MyCard(
                                          task: item,
                                          parentRemoveList: removeList),
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              MyTextField(parentAddList: addList, type: 1),
                            ]),
                          )),
                    ),
                    const SizedBox(width: 20),
                    DropRegion(
                      formats: Formats.standardFormats,
                      hitTestBehavior: HitTestBehavior.opaque,
                      onDropOver: (event) {
                        final item = event.session.items.first;
                        print(item);

                        if (event.session.allowedOperations
                            .contains(DropOperation.copy)) {
                          return DropOperation.copy;
                        } else {
                          return DropOperation.none;
                        }
                      },
                      onPerformDrop: (event) async {
                        final item = event.session.items.first;
                        final data = item.localData;
                        if (data is Map) {
                          updateList(
                              Task(
                                  desc: data['desc'],
                                  type: data['type'],
                                  id: data['id']),
                              2);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Row(
                                children: [
                                  Stack(children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      top: 11,
                                      left: 11,
                                      child: Image.asset(
                                        'lib/images/check.png',
                                        width: 20,
                                      ),
                                    ),
                                  ]),
                                  SizedBox(width: 10),
                                  Container(
                                      child: Text(
                                    'Concluído',
                                    style: GoogleFonts.bricolageGrotesque(
                                        color: const Color(0xff2c303f),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ],
                              ),
                              SizedBox(height: 20),
                              ListView.builder(
                                itemCount: _taskList
                                    .where((tsk) => tsk.type == 2)
                                    .toList()
                                    .length,
                                shrinkWrap: true,
                                key: GlobalKey(),
                                itemBuilder: (context, index) {
                                  final item = _taskList
                                      .where((tsk) => tsk.type == 2)
                                      .toList()[index];
                                  if (item.type == 2) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: MyCard(
                                          task: item,
                                          parentRemoveList: removeList),
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              MyTextField(parentAddList: addList, type: 2),
                            ]),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class Task {
  String? desc;
  int? type;
  int? id;

  factory Task.fromJson(Map<String, dynamic> jsonData) {
    return Task(
      id: jsonData['id'],
      desc: jsonData['desc'],
      type: jsonData['type'],
    );
  }

  static Map<String, dynamic> toMap(Task task) => {
        'id': task.id,
        'desc': task.desc,
        'type': task.type,
      };

  static String encode(List<Task> tasks) => json.encode(
        tasks.map<Map<String, dynamic>>((task) => Task.toMap(task)).toList(),
      );

  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromJson(item))
          .toList();

  Task({this.desc, this.type, this.id});
}
