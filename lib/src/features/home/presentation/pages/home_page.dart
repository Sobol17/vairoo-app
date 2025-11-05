import 'package:ai_note/src/features/disclaimer/domain/entities/disclaimer_type.dart';
import 'package:ai_note/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:ai_note/src/features/disclaimer/presentation/pages/disclaimer_screen.dart';
import 'package:ai_note/src/features/disclaimer/presentation/widgets/main_disclaimer_dialog.dart';
import 'package:ai_note/src/features/home/domain/entities/note.dart';
import 'package:ai_note/src/features/home/domain/repositories/note_repository.dart';
import 'package:ai_note/src/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (context) =>
          HomeController(repository: context.read<NoteRepository>())
            ..loadNotes(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureMainDisclaimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главный экран'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Уведомления',
            onPressed: _openNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.forum_outlined),
            tooltip: 'Чат',
            onPressed: _handleChatTap,
          ),
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, _) {
          return Center(child: Text('Главный экран в разработке'));
        },
      ),
    );
  }

  Future<void> _ensureMainDisclaimer() async {
    final controller = context.read<DisclaimerController>();
    final accepted = await controller.isAccepted(DisclaimerType.main);
    if (!mounted || accepted) {
      return;
    }
    final shouldMarkAccepted =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const MainDisclaimerDialog(),
        ) ??
        false;
    if (shouldMarkAccepted && mounted) {
      await controller.markAccepted(DisclaimerType.main);
    } else if (mounted) {
      // If user somehow dismissed, schedule dialog again on next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _ensureMainDisclaimer();
        }
      });
    }
  }

  Future<void> _handleChatTap() async {
    final controller = context.read<DisclaimerController>();
    var accepted = await controller.isAccepted(DisclaimerType.chat);
    if (!accepted) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => DisclaimerScreen(
          onAcknowledged: () => controller.markAccepted(DisclaimerType.chat),
        ),
      );
    }
  }

  void _openNotifications() {
    context.push('/home/notifications');
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note, required this.onDelete});

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
              decoration: const InputDecoration(labelText: 'Заголовок'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Содержание'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Отмена'),
          ),
        ],
      );
    },
  );
  titleController.dispose();
  contentController.dispose();
}
