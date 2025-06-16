import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:food_app/Model/item_model.dart';


class DatabaseHelper {

  static Database? _database;
  static const String _dbName = "food_items.db";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = "${directory.path}/$_dbName";
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''  
        CREATE TABLE items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          price TEXT,
          description TEXT,
          imagePath TEXT
        )
      ''');
    });
  }


  Future<void> insertItem(Item item) async {
    final db = await database;
    await db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        description: maps[i]['description'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  
  // Delete an item by its id
  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  
  // Update an existing item
  Future<void> updateItem(Item item) async {
    final db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
