import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/news_article.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            urlToImage TEXT,
            url TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(NewsArticle article) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'title': article.title,
        'description': article.description,
        'urlToImage': article.urlToImage,
        'url': article.url,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewsArticle>> fetchFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return NewsArticle(
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        urlToImage: maps[i]['urlToImage'] as String,
        url: maps[i]['url'] as String,
      );
    });
  }

  Future<void> deleteFavorite(String title) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
