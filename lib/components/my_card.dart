import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban/main.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class MyCard extends StatefulWidget {
  final Task task;
  final void Function(Task task) parentRemoveList;
  const MyCard({super.key, required this.task, required this.parentRemoveList});

  @override
  State<MyCard> createState() => _MyCardState(parentRemoveList: this.parentRemoveList);
}

class _MyCardState extends State<MyCard> {
  final void Function(Task task) parentRemoveList;

  List<Color> colors = <Color>[Color(0xffffffff), Color(0xfffbb732), Color(0xff7ed998)];

  _MyCardState({required this.parentRemoveList});

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (request) async { 
        final item = DragItem(
          localData: {'desc' : widget.task.desc, 'type' : widget.task.type, 'id' : widget.task.id},
        );
        return item;
       },
       allowedOperations: () => [DropOperation.copy],
      child: DraggableWidget(
        child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border(
                        bottom: BorderSide(
                          color: colors[widget.task.type ?? 0],
                          width: 4
                        )
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text('${widget.task.desc}',
                            style:  GoogleFonts.bricolageGrotesque(
                                    color: Color(0xff2c303f),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                         IconButton(
                          icon: const Icon(Icons.delete),
                          color: Color(0xff2c303f),
                          tooltip: 'Deletar',
                          onPressed: () {
                            parentRemoveList(widget.task);
                          }),
                      ],
                    ),
                  ),
      ),
    );
}
}