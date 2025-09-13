import 'package:englishkey/domain/entities/suggestion.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:englishkey/presentation/providers/suggestion_provider.dart';

class SuggestionScreen extends ConsumerStatefulWidget {
  const SuggestionScreen({super.key});

  @override
  ConsumerState<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends ConsumerState<SuggestionScreen> {
  final _textcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final suggestionState = ref.watch(suggestionProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sugerencias',
          style: TextStyle(fontSize: textTheme.titleSmall!.fontSize),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Agregar una sugerencia'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _textcontroller,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Escriba la sugerencia aqui',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor agregue una sugerencia';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(suggestionProvider.notifier)
                                .saveOrUpdate(
                                  Suggestion(text: _textcontroller.text),
                                );
                            _textcontroller.text = '';
                          }
                        },
                        child: Text('Agregar'),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body:
          suggestionState.suggestions.isNotEmpty
              ? ListView.builder(
                itemCount: suggestionState.suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestionState.suggestions;
                  return Stack(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(100),
                            width: 1.5,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        color: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withAlpha(100),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_note,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  suggestion[index].text,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        child: IconButton(
                          onPressed: () {
                            print('entro');
                            ref
                                .read(suggestionProvider.notifier)
                                .delete(
                                  int.parse(suggestion[index].id.toString()),
                                );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
              : Center(child: Text('Agregue una sugerencia')),
      drawer: CustomDrawer(),
    );
  }
}
