import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqliteflutter/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;
  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableNotes(
      ${NoteFields.id}$idType,
      ${NoteFields.isImportant}$boolType,
      ${NoteFields.number}$integerType,
      ${NoteFields.title}$textType,
      ${NoteFields.description}$textType,
      ${NoteFields.time}$textType,
    )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
