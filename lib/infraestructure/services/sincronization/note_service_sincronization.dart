import 'package:englishkey/infraestructure/datasources/cloud/notes_cloud_datasource_impl.dart';
import 'package:englishkey/infraestructure/repositories/cloud/notes_cloud_repository_impl.dart';
import 'package:englishkey/presentation/providers/notes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteServiceSincronization {
  late NotesCloudRepositoryImpl _cloudRepository;
  NoteServiceSincronization() {
    _cloudRepository = NotesCloudRepositoryImpl(
      datasource: NotesCloudDatasourceImpl(),
    );
  }

  Future<void> asyncNotes(WidgetRef ref) async {
    final providerRef = ref.read(notesProvider.notifier);

    var localnotes = ref.read(notesProvider).notes;

    //? 1. Guardo los datos creado localmente en la nube
    for (var note in localnotes) {
      if (!note.isAsync!) {
        note.isAsync = true;
        await _cloudRepository.create(note: note);
        await providerRef.updateNoteLocal(note);
      }
    }

    //? 2. Actualizo los datos que tengan las fechas diferentes
    final cloudNotes = await providerRef.notesTocloud();
    localnotes = ref.read(notesProvider).notes;

    for (var localNote in localnotes) {
      for (var cloudNote in cloudNotes) {
        if (localNote.id == cloudNote.id) {
          if (localNote.isUpdate != cloudNote.isUpdate) {
            await _cloudRepository.update(note: localNote);
          }
        }
      }
    }

    //? 3. Borrar los datos que ya no existen local en la nube
    if (localnotes.length == cloudNotes.length) return;

    final localIds =
        localnotes.map((n) => n.id?.toString()).whereType<String>().toSet();

    for (var cloud in cloudNotes) {
      final cloudId = cloud.id?.toString();
      if (cloudId != null && !localIds.contains(cloudId)) {
        await _cloudRepository.removeNote(id: cloudId);
      }
    }
  }
}
