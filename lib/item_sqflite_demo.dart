import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'menu_base.dart';
import 'menu_utils.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<void> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'sqflite_demo.db');
    developer.log('(DatabaseService) Database Path <$databasePath>');

    return null;
  }
}

Future<DatabaseService> _getDatabaseInfo() async {
  DatabaseService ret = DatabaseService._constructor();
  await ret.getDatabase();

  return ret;
}

class MenuItemSqfliteDemo extends StatelessWidget {
  const MenuItemSqfliteDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarForStdFunctional(context, functionalTitle),
      body: Container(
        margin: EdgeInsets.all(20),
        child: FutureBuilder<DatabaseService>(
          future: _getDatabaseInfo(),
          builder: (context, snapshot) {
            // 3. Handle the "Loading" state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            // 4. Hanbdle errors
            else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final retRec = snapshot.data!;
              const int lenToExtract =
                  1000; // set this to large value, after implementing scrollbars to allow full visual.
              final String allPaths = retRec.fileList
                  .map((file) => file.path)
                  .join('\n');
              return Column(
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
tempDir is <${retRec.tempDir.path.takeLast(lenToExtract)}>
appDocDir is <${retRec.appDocDir.path.takeLast(lenToExtract)}>
appSupportDir is <${retRec.appSupportDir.path.takeLast(lenToExtract)}>
externalDir is <${retRec.externalDir!.path.takeLast(lenToExtract)}>
downloadDir is <${retRec.downloadDir.path.takeLast(lenToExtract)}>

<${retRec.permissionOnDir}>
Content in directory <${retRec.dirToList!.path.takeLast(lenToExtract)}> size <${retRec.fileCount}>
$allPaths''',
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
              );
            }
          },
        ),
      ),
    );
  }
}
