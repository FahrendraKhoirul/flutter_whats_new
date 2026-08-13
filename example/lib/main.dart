import 'package:flutter/material.dart';
import 'package:flutter_whats_new/flutter_whats_new.dart';

final releases = [
  WhatsNewRelease(
    id: 'v2',
    version: '1.1.0',
    title: 'What’s New',
    items: [WhatsNewItem(WhatsNewItemType.added, 'Added a new feature.')],
  ),
  WhatsNewRelease(
    id: 'v1',
    version: '1.0.0',
    title: 'Welcome',
    items: [WhatsNewItem(WhatsNewItemType.added, 'Initial release.')],
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WhatsNew.initialize(releases: releases);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WhatsNew.showIfNeeded(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Home')));
  }
}
