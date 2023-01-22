import 'package:dictionary_riverpod/constants.dart';
import 'package:dictionary_riverpod/owlbot_api_key.dart';
import 'package:dictionary_riverpod/state.dart';
import 'package:dictionary_riverpod/widgets/favorites.dart';
import 'package:dictionary_riverpod/widgets/history.dart';
import 'package:dictionary_riverpod/widgets/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:owlbot_dart/owlbot_dart.dart';

class HomePage extends ConsumerWidget {
  final hBox = Hive.box<OwlBotResponse>(historyBox);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: ref.watch(searchControllerProvider.notifier).state,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              border: const UnderlineInputBorder(),
              suffix: IconButton(
                padding: const EdgeInsets.all(4.0),
                icon: const Icon(
                  Icons.clear,
                  size: 16.0,
                ),
                onPressed: () {
                  ref.read(searchControllerProvider.notifier).state.clear();
                },
              ),
              hintText: "enter word to search"),
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            _search(context, ref);
          },
        ),
      ),
      body: PageView(
        controller: ref.watch(pageViewController.notifier).state,
        onPageChanged: (page) {
          ref.read(selectedTabProvider.notifier).state = page;
        },
        children: [
          HomeTab(),
          HistoryPage(),
          FavoritesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(selectedTabProvider.notifier).state,
        onTap: (index) {
          ref.read(pageViewController.notifier).state.animateToPage(
                index,
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 500),
              );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),
        ],
      ),
    );
  }

  _search(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final query = ref.read(searchControllerProvider.notifier).state.text;
    if (query.isEmpty || ref.read(loadingProvider.notifier).state) return;
    ref.read(errorProvider.notifier).state = '';
    ref.read(loadingProvider.notifier).state = true;
    final box = Hive.box<OwlBotResponse>(historyBox);
    if (box.containsKey(query)) {
      ref.read(searchResultProvider.notifier).state = box.get(query);
      ref.read(loadingProvider.notifier).state = false;
      return;
    }

    final res = await OwlBot(token: TOKEN).define(word: query);
    if (res != null) {
      box.put(res.word, res);
    } else {
      ref.read(errorProvider.notifier).state = '404 Not found';
    }
    ref.read(searchResultProvider.notifier).state = res;
    ref.read(pageViewController.notifier).state.jumpToPage(0);
    ref.read(loadingProvider.notifier).state = false;
  }
}
