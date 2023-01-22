import 'package:dictionary_riverpod/widgets/dictionary_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:owlbot_dart/owlbot_dart.dart';

import '../constants.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<OwlBotResponse>(historyBox).listenable(),
      builder: (context, box, child) {
        final favs = box.values;
        if (favs.isEmpty) {
          return const Text("No history");
        }
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            ...favs.map((fav) {
              final res = fav;
              return DictionaryListItem(
                dictionaryItem: res,
              );
            }),
          ],
        );
      },
    );
  }
}
