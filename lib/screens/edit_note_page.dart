import 'package:flutter/material.dart';
import '../models/note.dart';
import '../db/note_database.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;
  const EditNotePage({super.key, this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    if (widget.note == null) {
      await NoteDatabase.instance.create(Note(title: title, content: content));
    } else {
      final updatedNote = widget.note!.copy(title: title, content: content);
      await NoteDatabase.instance.update(updatedNote);
    }

    final allNotes = await NoteDatabase.instance.readAllNotes();
    print('All Notes: $allNotes');

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? 'New Note' : 'Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}