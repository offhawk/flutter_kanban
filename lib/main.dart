import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban/components/my_card.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  List<Task> _taskList = [Task(type: 1, desc: 'teste', id: 1)];
  int taskId = 0;

  void updateList(Task task, int newIndex){
    setState(() {
      _taskList.removeWhere((task) => task.id == task.id);
      _taskList = [..._taskList, Task(desc: task.desc, type: newIndex, id: task.id)];
    });
  }

  void addList(Task task){
    setState(() {
      _taskList = [..._taskList, task];
      taskId++;
    });
  }

  void removeList(Task task){
    setState(() {
      _taskList.removeWhere((task) => task.id == task.id);
    });
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
    
                        if (event.session.allowedOperations.contains(DropOperation.copy)) {
                          return DropOperation.copy;
                        } else {
                          return DropOperation.none;
                        }
                      },
                      onPerformDrop: (event) async {
                      
                        final item = event.session.items.first;
                        final data = item.localData;
                        if(data is Map){
                          updateList(Task(desc: data['desc'], type: data['type'], id: data['id']), 0);
                        };

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height,
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
                            ListView.builder(
                              itemCount: _taskList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = _taskList[index];
                                if(item.type == 0){
                                  return MyCard(task: item);
                                }
                              },
                            ),
                          ])),
                    ),
                    const SizedBox(width: 20),
                    DropRegion(
                      formats: Formats.standardFormats,
                      hitTestBehavior: HitTestBehavior.opaque,
                      onDropOver: (event) {
                        
                        final item = event.session.items.first;
                        
                        if (event.session.allowedOperations.contains(DropOperation.copy)) {
                          return DropOperation.copy;
                        } else {
                          return DropOperation.none;
                        }
                      },
                      onPerformDrop: (event) async {
                      
                        final item = event.session.items.first;
                        final data = item.localData;
                        if(data is Map){
                          updateList(Task(desc: data['desc'], type: data['type'], id: data['id']), 1);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height,
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
                            ListView.builder(
                              itemCount: _taskList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = _taskList[index];
                                if(item.type == 1){
                                  return MyCard(task: item);
                                }
                              },
                            ),
                          ])
                      ),
                    ),
                    const SizedBox(width: 20),
                    DropRegion(
                      formats: Formats.standardFormats,
                      hitTestBehavior: HitTestBehavior.opaque,
                      onDropOver: (event) {
                        
                        final item = event.session.items.first;
                        print(item);
                        
                        if (event.session.allowedOperations.contains(DropOperation.copy)) {
                          return DropOperation.copy;
                        } else {
                          return DropOperation.none;
                        }
                      },
                      onPerformDrop: (event) async {
                      
                        final item = event.session.items.first;
                        final data = item.localData;
                        if(data is Map){
                          updateList(Task(desc: data['desc'], type: data['type'], id: data['id']), 2);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
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
                              itemCount: _taskList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = _taskList[index];
                                if(item.type == 2){
                                  return MyCard(task: item);
                                }
                              },
                            ),
                          ])
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

class Task{
  String? desc;
  int? type;
  int? id;

  Task({this.desc, this.type, this.id});
}