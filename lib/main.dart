import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/post_model.dart';
import 'screens/posts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // 1. initialise Hive
  Hive.registerAdapter(PostAdapter()); // 2. register the adapter

  // 3. open boxes early
  await Hive.openBox<Post>('postsBox');
  await Hive.openBox<Post>('favoritesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Offline Posts',
      debugShowCheckedModeBanner: false,
      home: PostsScreen(),
    );
  }
}
