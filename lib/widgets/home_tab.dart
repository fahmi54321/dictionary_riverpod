import 'package:dictionary_riverpod/constants.dart';
import 'package:dictionary_riverpod/state.dart';
import 'package:dictionary_riverpod/widgets/dictionary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:owlbot_dart/owlbot_dart.dart';

class HomeTab extends ConsumerWidget {
  final hBox = Hive.box<OwlBotResponse>(historyBox);
  HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = ref.watch(searchResultProvider.notifier).state;
    final error = ref.watch(errorProvider.notifier).state;
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        if (error.isNotEmpty) ...[
          Card(
            child: ListTile(
              title:
                  Text(ref.watch(searchControllerProvider.notifier).state.text),
              subtitle: Text(error),
              trailing: Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
        if (searchResult != null)
          DictionaryListItem(dictionaryItem: searchResult),
        if (searchResult == null && hBox.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              bottom: 4.0,
            ),
            child: Text(
              "Recent search",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          DictionaryListItem(
            dictionaryItem: hBox.getAt(0),
          ),
        ],
        if (searchResult == null && hBox.isEmpty) ...[
          const Card(
            child: ListTile(
              title: Text(
                  "You haven't used the disctionary, search some words to learn the definitions and more"),
            ),
          )
        ],
      ],
    );
  }
}
