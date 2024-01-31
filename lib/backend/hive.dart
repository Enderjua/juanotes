import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class NoteDatabase extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  @HiveField(2)
  late String date;

  @HiveField(3)
  late String photo;

  @HiveField(4)
  late bool isFavorite;
}

// Adaptörü ekleyin
class NoteDatabaseAdapter extends TypeAdapter<NoteDatabase> {
  @override
  final int typeId = 0;

  @override
  NoteDatabase read(BinaryReader reader) {
    return NoteDatabase()
      ..title = reader.readString()
      ..content = reader.readString()
      ..photo = reader.readString()
      ..date = reader.readString()
      ..isFavorite = reader.readBool();
  }

  @override
  void write(BinaryWriter writer, NoteDatabase obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.content);
    writer.writeString(obj.photo);
    writer.writeString(obj.date);
    writer.writeBool(obj.isFavorite);
  }
}


Future<Box<NoteDatabase>> addNote(String title, String content, String photo, String date, bool isFavorite) async {
  await Hive.openBox<NoteDatabase>('notes');

  final box = Hive.box<NoteDatabase>('notes');

  final note = NoteDatabase()
  ..title = title
  ..content = content
  ..photo = photo
  ..date = date
  ..isFavorite= isFavorite;

//   final noteId = box.add(note);
  box.add(note);
  return box;
}


Future<void> updateNote(int index, String newTitle, String newContent) async {
  // Hive kutusunu aç
  final box = await Hive.openBox<NoteDatabase>('notes');

  // İlgili indeksteki notu al
  NoteDatabase existingNote = box.getAt(index) as NoteDatabase;

  // Notu güncelle
  existingNote.title = newTitle;
  existingNote.content = newContent;

  // Güncellenmiş notu kutuya geri ekle
  box.putAt(index, existingNote);
}


Future<String> getAllNotesContent() async {
  final box = await Hive.openBox<NoteDatabase>('notes');

  // Box'tan tüm notları al
  final allNotes = box.values.toList();

  // Tüm not içeriklerini toplamak için bir string
  final StringBuffer notesContent = StringBuffer();

  for (int i = 0; i < allNotes.length; i++) {
    final note = allNotes[i];
  

    // Not içeriğini ekleyin
    notesContent.write('${note.content}\n');

    // Bir not bittiğinde ayrı bir satır ekleyin
    notesContent.write('Not $i bitti.\n\n');
  }

  

  return notesContent.toString();
}
