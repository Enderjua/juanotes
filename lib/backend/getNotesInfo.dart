// ignore_for_file: file_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notesapp/backend/hive.dart';

Future<List<NoteDatabase>> getFavoriteNotes() async {
    final box = await Hive.openBox<NoteDatabase>('notes');
    final List<NoteDatabase> allNotes = box.values.toList();
    return allNotes.where((note) => note.isFavorite).toList();
  }

  Future<List<NoteDatabase>> getAllNotes() async {
    final box = await Hive.openBox<NoteDatabase>('notes');
    return box.values.toList();
  }

  Future<int> getNonEmptyNotesCount() async {
    final box = await Hive.openBox<NoteDatabase>('notes');

    // Box'tan tüm notları al
    final allNotes = box.values;

    // Boş olmayan notları filtrele ve say
    final nonEmptyNotesCount = allNotes
        .where((note) => note.title.isNotEmpty || note.content.isNotEmpty)
        .length;

    return nonEmptyNotesCount;
  }