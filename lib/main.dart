import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban/components/my_card.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  List todo = ["aaa", "bbb"];
  List doing = ["ccc", "ddd"];
  List done = ["eee", "fff"];

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
            // Scrollable List - Horizontal
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
                          todo.add(data['content']);
                          if(data['list'] == 0){
                            todo.remove(data['content']);
                          } else if (data['list'] == 1){
                            doing.remove(data['content']);
                          } else if (data['list'] == 2){
                            done.remove(data['content']);
                          }
                        }

                        print(todo);

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height,
                          child: Column(children: [
                            Row(
                              // Header
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
                              itemCount: todo.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = todo[index];
                                return MyCard(content: item, list: 0);
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
                        doing.add(item);

                      // data reader is available now
                      // final reader = item.dataReader!;
                      
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height,
                        child: Column(children: [
                            Row(
                              // Header
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
                              itemCount: doing.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = doing[index];
                                return MyCard(content: item, list: 1);
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
                        
                        if (event.session.allowedOperations.contains(DropOperation.copy)) {
                          return DropOperation.copy;
                        } else {
                          return DropOperation.none;
                        }
                      },
                      onPerformDrop: (event) async {
                      
                        final item = event.session.items.first;
                        done.add(item);

                      // data reader is available now
                      // final reader = item.dataReader!;
                      
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(children: [
                            Row(
                              // Header
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
                              itemCount: done.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = done[index];
                                return MyCard(content: item, list: 3,);
                              },
                            ),
                          ])
                      ),
                    ),
                  ],
                ),
              ),
            )

            // A fazer
            // Em Andamento
            // Concluído
          ],
        )),
      ),
    );
  }
}

