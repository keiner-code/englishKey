import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/infraestructure/datasources/notes_datasource_impl.dart';
import 'package:englishkey/infraestructure/repositories/notes_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

enum NotesStatus { initial, pending, loading, success, error }

enum Priority { baja, media, alta }

class NotesState {
  final NotesStatus status;
  final String? errorMessage;
  final List<Note> notes;

  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.errorMessage = '',
  });

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    String? errorMessage,
  }) => NotesState(
    status: status ?? this.status,
    notes: notes ?? this.notes,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

class NotesNotifier extends StateNotifier<NotesState> {
  NotesNotifier({required this.repository}) : super(NotesState());
  NotesRepositoryImpl repository;
  Logger logger = Logger();

  String customCurrentTime() {
    return '${DateFormat("EEEE", "es").format(DateTime.now())} '
        '${DateFormat("d", "es").format(DateTime.now())} de '
        '${DateFormat("MMMM", "es").format(DateTime.now())} del '
        '${DateFormat("y", "es").format(DateTime.now())}';
  }

  void addOrUpdateNote(Note currentNote) async {
    state = state.copyWith(status: NotesStatus.loading, errorMessage: '');

    try {
      final wasNew = currentNote.id == null;
      currentNote.date = customCurrentTime();

      final newNote = await repository.addNoteOrUpdate(note: currentNote);

      if (wasNew) {
        //save
        state = state.copyWith(notes: [...state.notes, newNote]);
      }

      if (currentNote.id != null) {
        //update
        state = state.copyWith(
          notes:
              state.notes.map((note) {
                if (note.id == currentNote.id) {
                  return currentNote;
                }
                return note;
              }).toList(),
        );
      }

      state = state.copyWith(status: NotesStatus.success);
      await Future.delayed(Duration(seconds: 1));
      state = state.copyWith(status: NotesStatus.initial);
    } catch (e) {
      logger.e(e);
      state = state.copyWith(
        status: NotesStatus.error,
        errorMessage: 'Error interno ${e.toString()}',
      );
    }
  }

  void changePriority(Note note) {
    late String newPriority;
    if (note.priority == 'baja') {
      newPriority = 'media';
    }
    if (note.priority == 'media') {
      newPriority = 'alta';
    }
    if (note.priority == 'alta') {
      newPriority = 'baja';
    }

    addOrUpdateNote(
      Note(
        title: note.title,
        content: note.title,
        priority: newPriority,
        id: note.id,
      ),
    );
  }

  void listNotes() async {
    state = state.copyWith(status: NotesStatus.loading);
    final notes = await repository.listNotes();
    state = state.copyWith(notes: notes, status: NotesStatus.success);
    await Future.delayed(Duration(seconds: 2));
    state = state.copyWith(status: NotesStatus.initial);
  }

  void removeNote(String id) async {
    try {
      state = state.copyWith(status: NotesStatus.loading);
      final isDeleted = await repository.removeNote(id: id);
      if (!isDeleted) {
        throw Exception();
      }
      state.notes.removeWhere((note) => note.id == int.parse(id));
      state = state.copyWith(status: NotesStatus.success);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al eliminar la nota',
        status: NotesStatus.error,
      );
      throw Exception('$e');
    }
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  return NotesNotifier(
    repository: NotesRepositoryImpl(datasource: NotesDatasourceImpl()),
  )..listNotes();
});
