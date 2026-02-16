import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'menu_base.dart';
// import 'menu_utils.dart';

/*
    This Service class sheilds all database opertions for the Database object embedded.
*/
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._constructor();
  static Database? _db;

  DatabaseService._constructor() {
    developer.log(
      "Info: (DatabaseService._constructor) invoked, no logic yet.",
    );
  }

  // 3. The Factory Constructor
  // When someone calls ThemeManager(), they get the existing instance.
  factory DatabaseService() {
    developer.log(
      'Info: (factory DatabaseSevice) invoked to return _instance.',
    );
    return _instance;
  }
  /*
  Future<Database> get database async {
    // If database exists, return it; otherwise, initialize it
    if (_database != null) return _database!;

    _database = await _initDB('items_database.db');
    return _database!;
  }
*/
  Future<Database> get database async {
    developer.log('Info: (DatabaseService.database) just entered');
    // If database exists, return it; otherwise, initialize it
    if (_db != null) {
      developer.log('Info: (DatabaseService.database) returning existing _db');
      return _db!;
    }

    _db = await _initDB('master_sqflite.db');
    developer.log(
      'Info: (DatabaseService.database) returning newly created db and will check for _db first',
    );
    return _db!;
  }

  Future<Database> _initDB(String dbName) async {
    developer.log('Info: (DatabaseService._initDB) just entered');
    // Get the default directory for databases on Android/iOS
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    developer.log(
      'Info: (DatabaseService._initDB) db full path will be <$path>. about to call openDatabase()',
    );

    return await openDatabase(
      path,
      version: 1, // Increment this if you change the schema later
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    developer.log('Info: (DatabaseService._createDB) just entered');
    await db.execute('''
        CREATE TABLE items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          parent_id INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          image_name TEXT,
          FOREIGN KEY (parent_id) REFERENCES items (id)
        )
      ''');
    developer.log('Info: (DatabaseService._createDB) about to exit');
  }

  Future<String> get metaDataText async {
    developer.log('Info: (DatabaseService.metaDataText) just entered)');
    return "abc\nxyz";
  }

  Future close() async {
    developer.log('Info: (DatabaseService.close) just entered)');

    final db = await _instance.database;
    db.close();
  }
}

class MenuItemSqfliteDemo extends StatefulWidget {
  const MenuItemSqfliteDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  State<MenuItemSqfliteDemo> createState() => _MenuItemSqfliteDemoWidgetState();
}

class _MenuItemSqfliteDemoWidgetState extends State<MenuItemSqfliteDemo> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarForStdFunctional(context, widget.functionalTitle),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                // vertical scrollbar
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    // Horizontal Scrollbar
                    thumbVisibility: true,
                    notificationPredicate: (notif) =>
                        notif.depth == 1, // targets the horizontal scroll
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '''
Meta data is <${_dbService.metaDataText}>
''',
                          softWrap: false,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
