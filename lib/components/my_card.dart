import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban/main.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class MyCard extends StatefulWidget {
  final Task task;
  const MyCard({super.key, required this.task});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text('${widget.task.desc}',
                    style:  GoogleFonts.bricolageGrotesque(
                            color: Color(0xff2c303f),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                  ),
      ),
    );
}
}