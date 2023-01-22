import 'package:dictionary_riverpod/constants.dart';
import 'package:dictionary_riverpod/widgets/dictionary_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:owlbot_dart/owlbot_dart.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<OwlBotResponse>(favoritesBox).listenable(),
      builder: (context, box, child) {
        final favs = box.values;
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
