import 'package:flutter/material.dart';
import '../../services/storage_service.dart';

class BusinessNotesPage extends StatefulWidget {
  const BusinessNotesPage({super.key});

  @override
  State<BusinessNotesPage> createState() => _BusinessNotesPageState();
}

class _BusinessNotesPageState extends State<BusinessNotesPage> {
  final StorageService storageService = StorageService();
  List<BusinessNote> businessNotes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    storageService.initializeDemoData();
    setState(() {
      businessNotes = storageService.getBusinessNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeNotes = businessNotes.where((note) => !note.isCompleted).toList();
    final completedNotes = businessNotes.where((note) => note.isCompleted).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Business Notes'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Add Note Section
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Add Note',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your business note...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _addNote(value.trim());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Notes List
          Expanded(
            child: businessNotes.isEmpty
                ? _buildEmptyState()
                : _buildNotesList(activeNotes, completedNotes),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + button to add your first business note',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<BusinessNote> activeNotes, List<BusinessNote> completedNotes) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (activeNotes.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text(
            'Active Notes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          ...activeNotes.map((note) => _buildNoteCard(note)).toList(),
        ],
        if (completedNotes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Completed Notes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          ...completedNotes.map((note) => _buildNoteCard(note)).toList(),
        ],
      ],
    );
  }

  Widget _buildNoteCard(BusinessNote note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: note.isCompleted,
          onChanged: (value) {
            _toggleNoteCompletion(note);
          },
        ),
        title: Text(
          note.content,
          style: TextStyle(
            decoration: note.isCompleted
                ? TextDecoration.lineThrough
                : null,
            color: note.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          _formatDate(note.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _editNote(note),
              tooltip: 'Edit Note',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _deleteNote(note),
              tooltip: 'Delete Note',
            ),
          ],
        ),
        onTap: () => _editNote(note),
      ),
    );
  }

  void _addNote(String content) {
    final note = BusinessNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    storageService.addBusinessNote(note);
    _loadNotes();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editNote(BusinessNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: TextEditingController(text: note.content),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(BusinessNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              storageService.deleteBusinessNote(note.id);
              Navigator.pop(context);
              _loadNotes();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleNoteCompletion(BusinessNote note) {
    final updatedNote = BusinessNote(
      id: note.id,
      content: note.content,
      isCompleted: !note.isCompleted,
      createdAt: note.createdAt,
    );

    storageService.updateBusinessNote(updatedNote);
    _loadNotes();
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Business Note'),
        content: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your note...',
          ),
          maxLines: 3,
          onSubmitted: (value) {
            Navigator.pop(context);
            if (value.trim().isNotEmpty) {
              _addNote(value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddNoteField();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteField() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your note...',
          ),
          maxLines: 3,
          onSubmitted: (value) {
            Navigator.pop(context);
            if (value.trim().isNotEmpty) {
              _addNote(value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddNoteField();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
