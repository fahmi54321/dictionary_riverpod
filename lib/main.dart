import 'package:dictionary_riverpod/constants.dart';
import 'package:dictionary_riverpod/owlbot_res_adapter.dart';
import 'package:dictionary_riverpod/pages/home_page.dart';
import 'package:dictionary_riverpod/widgets/favorites.dart';
import 'package:dictionary_riverpod/widgets/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:owlbot_dart/owlbot_dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OwlBotResAdapter());
  Hive.registerAdapter(OwlBotDefinitionAdapter());
  await Hive.openBox<OwlBotResponse>(favoritesBox);
  await Hive.openBox<OwlBotResponse>(historyBox);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.red,
          ),
        ),
      ),
      home: HomePage(),
      routes: {
        "favorites": (_) => FavoritesPage(),
        "history": (_) => HistoryPage(),
      },
    );
  }
}
