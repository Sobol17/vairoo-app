import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ai_note/src/features/home/domain/entities/note.dart';
import 'package:ai_note/src/features/home/domain/repositories/note_repository.dart';
import 'package:ai_note/src/features/home/presentation/controllers/home_controller.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_empty_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController(
        repository: context.read<NoteRepository>(),
      )..loadNotes(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Note'),
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notes.isEmpty) {
            return const HomeEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => _NoteTile(
              note: controller.notes[index],
              onDelete: () => controller.removeNote(controller.notes[index].id),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: controller.notes.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({
    required this.note,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

Future<void> _showNewNoteDialog(BuildContext context) async {
  final controller = context.read<HomeController>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final navigator = Navigator.of(dialogContext);
      return AlertDialog(
        title: const Text('Новая заметка'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Содержание',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              if (title.isNotEmpty || content.isNotEmpty) {
                await controller.addNote(title: title, content: content);
              }
              navigator.pop();
            },
            child: const Text('Сохранить'),
          ),
        ],
      );
    },
  );
  titleController.dispose();
  contentController.dispose();
}
