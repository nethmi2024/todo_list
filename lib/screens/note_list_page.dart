import 'package:flutter/material.dart';
import '../models/note.dart';
import '../db/note_database.dart';
import 'edit_note_page.dart';
import '../widgets/note_tile.dart';
import 'note_detail_page.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshNotes();
    searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future refreshNotes() async {
    notes = await NoteDatabase.instance.readAllNotes();
    _filterNotes();
  }

  void _filterNotes() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToEditNote({Note? note}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditNotePage(note: note),
      ),
    );
    refreshNotes();
  }

  void _navigateToViewNote(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final isDark = themeProvider.themeMode == ThemeMode.dark;
              return Switch(
                value: isDark,
                onChanged: (value) => themeProvider.toggleTheme(value),
                activeColor: Colors.white,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Notes...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text('No matching notes found.'))
                : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return NoteTile(
                  note: note,
                  onTap: () => _navigateToEditNote(note: note),
                  onDelete: () async {
                    await NoteDatabase.instance.delete(note.id!);
                    refreshNotes();
                  },
                  onTogglePin: () async {
                    final updatedNote = note.copy(isPinned: !note.isPinned);
                    await NoteDatabase.instance.update(updatedNote);
                    refreshNotes();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _navigateToEditNote(),
      ),
    );
  }
}