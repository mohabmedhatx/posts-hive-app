import 'package:hive/hive.dart';

import '../models/post_model.dart';

/// Manages the user's favorite posts in their own Hive box.
///
/// A separate box is required because PostService.getPosts() calls
/// postsBox.clear() on every refresh, which would wipe the favorites.
class FavoritesService {
  static const String boxName = 'favoritesBox';

  // The box is already opened in main.dart, so reading is synchronous.
  Box<Post> get _box => Hive.box<Post>(boxName);

  /// True if a post with this id is saved as a favorite.
  bool isFavorite(int id) => _box.containsKey(id);

  /// Adds the post to favorites, or removes it if it is already there.
  Future<void> toggleFavorite(Post post) async {
    if (_box.containsKey(post.id)) {
      await _box.delete(post.id);
    } else {
      // A HiveObject can only live in one box at a time,
      // so we save a copy instead of the instance from postsBox.
      final copy = Post(
        id: post.id,
        title: post.title,
        body: post.body,
        userId: post.userId,
      );
      await _box.put(post.id, copy);
    }
  }

  /// All saved favorites.
  List<Post> getFavorites() => _box.values.toList();
}
