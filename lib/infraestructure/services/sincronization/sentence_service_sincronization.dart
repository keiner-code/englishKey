import 'package:englishkey/infraestructure/repositories/cloud/sentences_cloud_repository_impl.dart';
import 'package:englishkey/presentation/providers/senteces_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SentenceServiceSincronization {
  late SentencesCloudRepositoryImpl _cloudRepositoryImpl;

  SentenceServiceSincronization() {
    _cloudRepositoryImpl = SentencesCloudRepositoryImpl();
  }

  Future<void> asyncSentence(WidgetRef ref) async {
    //? 0. Obtengo los datos
    final localProvider = ref.read(sentencesProvider.notifier);
    final localSentences =
        await ref.read(sentencesProvider.notifier).localFindAll();

    //? 1. Guardo los datos creado localmente en la nube
    for (var sentence in localSentences) {
      if (!sentence.isAsync) {
        sentence.isAsync = true;
        await _cloudRepositoryImpl.create(sentence: sentence);
        await localProvider.createOrUpdate(sentence);
      }
    }

    final currentLocalSentences =
        await ref.read(sentencesProvider.notifier).localFindAll();
    final cloudSentences = await _cloudRepositoryImpl.getFindAll();

    //? 2. Actualizo los datos que tengan las fechas diferentes
    for (var sentenceLocal in currentLocalSentences) {
      for (var sentenceCloud in cloudSentences) {
        if (sentenceCloud.id == sentenceLocal.id) {
          if (sentenceLocal.isUpdate != sentenceCloud.isUpdate) {
            await _cloudRepositoryImpl.update(sentence: sentenceLocal);
          }
          break;
        }
      }
    }

    //! La funcion de borrar no esta implementada en este modulo
  }
}
