import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban/main.dart';

class MyTextField extends StatefulWidget  {
    
  final void Function(Task task) parentAddList;
  final int type;
  const MyTextField({super.key, required this.parentAddList, required this.type});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    FocusNode myFocusNode = FocusNode();

    void dispose() {
      textController.dispose();
    }

    final typeWrapper = widget.type;
    final functionWrapper = widget.parentAddList;

    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: TextField(
                controller: textController,
                onSubmitted: (text) {
                  Task task = Task(desc: text, type: widget.type);
                  widget.parentAddList(task);
                  dispose();
                },
                focusNode: myFocusNode,
                style: GoogleFonts.bricolageGrotesque(color: Color(0xff2c303f)),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff2c303f)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff2c303f)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: unnecessary_string_interpolations
                  filled: false,
                  suffixIcon: IconButton(
                          onPressed: () {
                            Task teste = Task(desc: textController.text, type: typeWrapper);
                            functionWrapper(teste);
                            dispose();
                          },
                          icon: Icon(Icons.add),
                        ),
                  labelText: 'Adicionar',
                ),
              ),
            );
  }
}