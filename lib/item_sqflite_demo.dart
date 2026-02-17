import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'menu_base.dart';
// import 'menu_utils.dart';

/*
    This Service class sheilds all database opertions for the Database object embedded.
*/
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._constructor();
  static Database? _db;
  static String? path;

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
    // final dbPath = await getDatabasesPath();
    var dbPath = "/storage/emulated/0/Download";
    var fileSpec = join(dbPath, dbName); // will be updated later, if needed.
    path = fileSpec;

    developer.log(
      'Info: (DatabaseService._initDB)(1) db full path will be <$fileSpec>. about to do directory validation before calling openDatabase()',
    );

    try {
      final directory = Directory(dbPath);
      await directory.create(recursive: true);
      developer.log(
        'Info: (DatabaseService._initDB) Directory <$dbPath> s writable and directory created.',
      );
    } catch (e) {
      // Log the error or send to an analytics service
      developer.log(
        'Warn: primary accessing database directory of <$dbPath>. Thiis is possible for device emulator. Exception: $e',
      );
      // will use a secondary directory
      final secondaryPath = await getTemporaryDirectory();
      developer.log('Info: will use secondary directory <$secondaryPath.path>');
      fileSpec = join(secondaryPath.path, dbName);
      developer.log(
        'Info: (DatabaseService._initDB)(2) db full path will be <$fileSpec>. about to call openDatabase()',
      );
    }
    return await openDatabase(
      fileSpec,
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
          FOREIGN KEY (parent_id) REFERENCES items (id),
          UNIQUE(name, parent_id) -- ensure no duplication of name under each parent.
        )
      ''');
    developer.log('Info: (DatabaseService._createDB) about to exit');
  }

  Future<String> get pathText async {
    developer.log('Info: (DatabaseService.pathText) just entered)');

    return path ?? '';
  }

  Future<String> get metaDataText async {
    developer.log('Info: (DatabaseService.metaDataText) just entered)');
    final db = await _instance.database;

    // rawQuery returns List<Map<String, dynamic>>
    var result = await db.rawQuery('SELECT COUNT(*) FROM items');

    // sqflite_common helper to easily parse the count
    int? count = Sqflite.firstIntValue(result);

    // rawQuery() returns List<Map<String, dynamic>>
    var rowResultObj = await db.rawQuery('SELECT * FROM items LIMIT 3');
    String rowsText = rowResultObj
        .map((row) => "${row['id']}: ${row['name']}\t${row['description']}")
        .join("\n");

    return """record count is <${count ?? 0}>
First few rows:
$rowsText""";
  }

  // Method to add a row
  Future<int> addRow(String name, String description, int parentId) async {
    final db = await _instance.database;
    return await db.insert(
      'items', // table name
      {'name': name, 'description': description, 'parent_id': parentId},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Method to drop a row
  Future<void> dropRow(String name, int parentId) async {
    final db = await _instance.database;
    await db.delete('items', where: 'name = ? and parent_id = ?', whereArgs: [name, parentId]);
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
  // late Future<String> _metaDataFuture;
  String? _metaDataFuture;
  String? _path;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshMetaData();
  }

  // Updates the UI with the current count from the DB
  Future<void> _refreshMetaData() async {
    final tempMetaData = await _dbService.metaDataText;
    final tempPath = await _dbService.pathText;
    setState(() {
      _metaDataFuture = tempMetaData;
      _path = tempPath;
    });
  }

  // Handles adding the item and refreshing the view
  Future<void> _handleAddItem() async {
    if (_nameController.text.isNotEmpty) {
      developer.log(
        'Info: (MenuItemSqfliteDemo._handleAddItem) about to add a new row with name <${_nameController.text}>...',
      );
      await _dbService.addRow(
        _nameController.text,
        "description for ${_nameController.text}",
        0,
      );
      _nameController.clear();
      await _refreshMetaData();
    }
  }

  // Handles adding the item and refreshing the view
  Future<void> _handleRemoveItem() async {
    if (_nameController.text.isNotEmpty) {
      developer.log(
        'Info: (MenuItemSqfliteDemo._handleRemoveItem) about to remove a row by name <${_nameController.text}>...',
      );

      await _dbService.dropRow(
        _nameController.text,
        0,
      );

      _nameController.clear();
      await _refreshMetaData();
    }
  }

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
Path is <$_path>
Meta data is <$_metaDataFuture>
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
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _handleAddItem,
                  icon: Icon(Icons.add),
                  label: Text("Add Item"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _handleRemoveItem,
                  icon: Icon(Icons.remove),
                  label: Text("Remove Item"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
