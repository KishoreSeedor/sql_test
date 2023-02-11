final String tableNotes = 'notes';

class NoteFileds {
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];

  static final String id = '_id';
  static final String number = 'number';
  static final String isImportant = 'isImportant';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  final int? id;
  final int number;
  final bool isImportant;
  final String title;
  final String description;
  final DateTime createTime;

  const Note(
      {this.id,
      required this.number,
      required this.isImportant,
      required this.title,
      required this.description,
      required this.createTime});

  Note copy({
    int? id,
    int? number,
    bool? isImportant,
    String? title,
    String? description,
    DateTime? createTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createTime: createTime ?? this.createTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFileds.id] as int?,
        number: json[NoteFileds.number] as int,
        isImportant: json[NoteFileds.isImportant] == 1,
        title: json[NoteFileds.title] as String,
        description: json[NoteFileds.description] as String,
        createTime: DateTime.parse(json[NoteFileds.time] as String),
      );

  Map<String, Object?> toJson() => {
        NoteFileds.id: id,
        NoteFileds.number: number,
        NoteFileds.isImportant: isImportant ? 1 : 0,
        NoteFileds.title: title,
        NoteFileds.description: description,
        NoteFileds.time: createTime.toIso8601String(),
      };
}
