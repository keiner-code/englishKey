import 'package:englishkey/presentation/providers/senteces_provider.dart';
import 'package:englishkey/presentation/widget/shared/alert_dialog_sentence_item.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SentencesScreen extends ConsumerStatefulWidget {
  const SentencesScreen({super.key});

  @override
  ConsumerState<SentencesScreen> createState() => _SentencesScreenState();
}

class _SentencesScreenState extends ConsumerState<SentencesScreen> {
  bool _showSearch = false;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sentencesProvider);
    final textTheme = Theme.of(context).textTheme;

    // mapSentenceList: List<Map<String, List<Sentence>>>
    // Filtrado por query
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered =
        state.mapSentenceList
            .map((group) {
              final category = group.keys.first;
              final list = group.values.first;
              if (query.isEmpty) return MapEntry(category, list);
              final sub =
                  list
                      .where((s) => s.sentence.toLowerCase().contains(query))
                      .toList();
              return MapEntry(category, sub);
            })
            .where((entry) => entry.value.isNotEmpty)
            .toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child:
              _showSearch
                  ? TextField(
                    key: const ValueKey('search'),
                    controller: _searchCtrl,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Buscar oración…',
                      border: InputBorder.none,
                    ),
                  )
                  : Text(
                    'Completa las oraciones',
                    style: textTheme.titleMedium,
                  ),
        ),
        leadingWidth: 56,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        actions: [
          IconButton(
            tooltip: _showSearch ? 'Cerrar búsqueda' : 'Buscar',
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                _searchCtrl.clear();
              });
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Builder(
          builder: (_) {
            if (state.mapSentenceList.isEmpty) {
              return _EmptyState(
                title: 'Sin oraciones',
                subtitle: 'Aún no hay contenido para practicar.',
                icon: Icons.inbox_outlined,
              );
            }
            if (query.isNotEmpty && filtered.isEmpty) {
              return _EmptyState(
                title: 'Sin resultados',
                subtitle:
                    'No encontramos oraciones que coincidan con “$query”.',
                icon: Icons.search_off,
              );
            }

            return ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final entry = filtered[index];
                final category = entry.key;
                final sentences = entry.value;

                return _CategoryCard(
                  title: category,
                  count: sentences.length,
                  children: List.generate(sentences.length, (i) {
                    final s = sentences[i];
                    return ListTile(
                      dense: false,
                      leading: CircleAvatar(
                        radius: 14,
                        child: Text('${i + 1}', style: textTheme.labelSmall),
                      ),
                      title: Text(s.sentence, style: textTheme.bodyLarge),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap:
                          () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialogSentenceItem(
                                isUpdate: true,
                                selectedSentence: category,
                                sentenceText: s.sentence,
                                idSentenceItem: s.id,
                              );
                            },
                          ),
                    );
                  }),
                );
              },
            );
          },
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String title;
  final int count;
  final List<Widget> children;
  const _CategoryCard({
    required this.title,
    required this.count,
    required this.children,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        // Quita el splash fuerte del ExpansionTile
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _expanded,
          onExpansionChanged: (v) => setState(() => _expanded = v),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          children: [
            const Divider(height: 1),
            ...widget.children,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(title, style: t.titleMedium),
            const SizedBox(height: 6),
            Text(subtitle, style: t.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
