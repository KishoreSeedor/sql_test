import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite_test/db/notes_database.dart';
import 'package:sqflite_test/pages/detail_page.dart';
import 'package:sqflite_test/pages/edit_page.dart';

import '../models/note.dart';
import '../widget/note_card_widget.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshNote();
  }

  @override
  void dispose() {
    NotesDatabase.instanse.database;
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instanse.readALLNote();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQL Test"),
        actions: [
          Icon(Icons.search),
          SizedBox(
            width: 21,
          )
        ],
      ),
      body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Center(
                      child: Text("No NOtes"),
                    )
                  : buildNotes()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEditNotePage()));
          refreshNote();
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: notes.length,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        itemBuilder: (BuildContext context, int index) {
          final note = notes[index];

          return GestureDetector(
            onTap: (() async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteDetailsPage(noteId: note.id!)));
              refreshNote();
            }),
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
