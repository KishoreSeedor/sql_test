import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_test/models/note.dart';

class NotesDatabase {
  static final NotesDatabase instanse = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFileds.id} $idType, 
  ${NoteFileds.isImportant} $boolType,
  ${NoteFileds.number} $integerType,
  ${NoteFileds.title} $textType,
  ${NoteFileds.description} $textType,
  ${NoteFileds.time} $textType
  )
''');
  }

  Future<Note> create(Note note) async {
    final db = await instanse.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instanse.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFileds.values,
      where: "${NoteFileds.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("ID $id not Found");
    }
  }

  Future<List<Note>> readALLNote() async {
    final db = await instanse.database;
    final orderBy = '${NoteFileds.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instanse.database;
    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFileds.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instanse.database;
    return db.delete(
      tableNotes,
      where: "${NoteFileds.id} = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instanse.database;

    db.close();
  }
}
