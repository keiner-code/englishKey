import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/infraestructure/datasources/cloud/notes_cloud_datasource_impl.dart';
import 'package:englishkey/infraestructure/datasources/local/notes_local_datasource_impl.dart';
import 'package:englishkey/infraestructure/repositories/cloud/notes_cloud_repository_impl.dart';
import 'package:englishkey/infraestructure/repositories/local/notes_local_repository_impl.dart';
import 'package:englishkey/presentation/providers/connection_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  NotesNotifier({
    required this.localRepository,
    required this.cloudRepository,
    required this.ref,
  }) : super(NotesState());
  NotesLocalRepositoryImpl localRepository;
  NotesCloudRepositoryImpl cloudRepository;
  Ref ref;
  Logger logger = Logger();

  String customCurrentTime() {
    return '${DateFormat("EEEE", "es").format(DateTime.now())} '
        '${DateFormat("d", "es").format(DateTime.now())} de '
        '${DateFormat("MMMM", "es").format(DateTime.now())} del '
        '${DateFormat("y", "es").format(DateTime.now())}';
  }

  Future<void> addOrUpdateNote(Note currentNote) async {
    state = state.copyWith(status: NotesStatus.loading, errorMessage: '');
    try {
      final wasNew = currentNote.id == null;
      final hasInternet = ref
          .read(connectionProvider)
          .maybeWhen(data: (has) => has, orElse: () => false);

      final user = hasInternet ? FirebaseAuth.instance.currentUser : null;

      currentNote.date = customCurrentTime();
      final newNote = await localRepository.addNoteOrUpdate(note: currentNote);

      if (wasNew) {
        //save
        state = state.copyWith(
          notes: [newNote, ...state.notes],
          status: NotesStatus.success,
        );
        if (user != null) {
          newNote.isAsync = true;
          await cloudRepository.create(note: newNote);
          await localRepository.addNoteOrUpdate(note: newNote);
        }

        await Future.delayed(Duration(seconds: 1));
        state = state.copyWith(status: NotesStatus.initial);
        return;
      }

      //update

      state = state.copyWith(
        notes:
            state.notes.map((note) {
              if (note.id == currentNote.id) {
                return currentNote;
              }
              return note;
            }).toList(),
        status: NotesStatus.success,
      );

      if (user != null) {
        final response = await cloudRepository.update(note: currentNote);
        if (response != null) {
          state = state.copyWith(
            errorMessage: response,
            status: NotesStatus.error,
          );
          return;
        }
      }

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
    final notes = await localRepository.listNotes();
    state = state.copyWith(
      notes: notes.reversed.toList(),
      status: NotesStatus.success,
    );
    await Future.delayed(Duration(seconds: 2));
    state = state.copyWith(status: NotesStatus.initial);
  }

  Future<List<Note>> notesTocloud() async {
    return await cloudRepository.listNotes();
  }

  Future<void> updateNoteLocal(Note note) async {
    await localRepository.addNoteOrUpdate(note: note);
  }

  Future<void> removeNote(String id) async {
    try {
      state = state.copyWith(status: NotesStatus.loading, errorMessage: '');
      final isDeleted = await localRepository.removeNote(id: id);
      if (!isDeleted) {
        throw Exception();
      }
      state.notes.removeWhere((note) => note.id == int.parse(id));

      final hasInternet = ref
          .read(connectionProvider)
          .maybeWhen(data: (has) => has, orElse: () => false);

      final user = hasInternet ? FirebaseAuth.instance.currentUser : null;

      if (user != null) {
        final response = await cloudRepository.removeNote(id: id);
        if (!response) {
          state = state.copyWith(
            errorMessage: "Error al eliminar en la nube",
            status: NotesStatus.error,
          );
          return;
        }
      }

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
    ref: ref,
    localRepository: NotesLocalRepositoryImpl(
      datasource: NotesLocalDatasourceImpl(),
    ),
    cloudRepository: NotesCloudRepositoryImpl(
      datasource: NotesCloudDatasourceImpl(),
    ),
  )..listNotes();
});
