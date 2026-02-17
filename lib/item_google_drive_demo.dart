import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as gdrive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'menu_base.dart';
import 'item_sqflite_demo.dart';
// import 'menu_utils.dart';

class MenuItemGoogleDriveDemo extends StatefulWidget {
  const MenuItemGoogleDriveDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  State<MenuItemGoogleDriveDemo> createState() =>
      _MenuItemGoogleDriveDemoWidgetState();
}

class _MenuItemGoogleDriveDemoWidgetState
    extends State<MenuItemGoogleDriveDemo> {
  final DatabaseService _dbService = DatabaseService();
  // late Future<String> _metaDataFuture;
  String? _metaDataFuture;
  String? _path;
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _refreshMetaData();
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    _nameController.dispose();
    super.dispose();
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

      await _dbService.dropRow(_nameController.text, 0);

      _nameController.clear();
      await _refreshMetaData();
    }
  }

  // Handles deletion of the database and the associate file.
  void _handleDeleteDatabase() async {
    await _dbService.deleteDatabaseAndFile();
    _nameController.clear();
    // await _refreshMetaData();
    developer.log(
      'INfo: (MenuItemSqfliteDemo._handleDeleteDatabase) the mount value is <$mounted>',
    );
    if (!mounted) {
      Navigator.pop; // Goes back to the previous screen
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
                controller: _verticalScrollController,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    // Horizontal Scrollbar
                    thumbVisibility: true,
                    controller: _horizontalScrollController,
                    notificationPredicate: (notif) =>
                        notif.depth == 1, // targets the horizontal scroll
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
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
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _handleAddItem,
                    icon: Icon(Icons.add),
                    label: Text("Add Item"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(5, 50)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _handleRemoveItem,
                    icon: Icon(Icons.remove),
                    label: Text("Remove Item"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(5, 50)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            ElevatedButton.icon(
              onPressed: _handleDeleteDatabase,
              icon: Icon(Icons.delete_forever),
              label: Text("Delete Database"),
              style: ElevatedButton.styleFrom(minimumSize: Size(5, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
