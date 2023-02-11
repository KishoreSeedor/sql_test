import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_test/db/notes_database.dart';

import '../models/note.dart';
import 'edit_page.dart';

class NoteDetailsPage extends StatefulWidget {
  final int noteId;
  const NoteDetailsPage({super.key, required this.noteId});

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState((() => isLoading = true));

    this.note = await NotesDatabase.instanse.readNote(widget.noteId);

    setState((() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(" First Page"),
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      DateFormat.yMMMd().format(
                        note.createTime,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      note.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ));
  }

  Widget deleteButton() => IconButton(
      onPressed: () async {
        await NotesDatabase.instanse.delete(widget.noteId);
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.delete));

  Widget editButton() => IconButton(
      onPressed: () async {
        if (isLoading) return;

        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEditNotePage(note: note)));
        refreshNote();
      },
      icon: Icon(Icons.edit));
}
