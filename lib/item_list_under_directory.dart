import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
//import 'package:storage_info/storage_info.dart';
import 'menu_base.dart';
import 'menu_utils.dart';

/*
TODO: This function is still under development, by transforming from item_path_provider_demo.dart
      doing it little by little.
      The goal is output to a full-feature scrollable Text fields.
*/

Future<
  ({
    Directory tempDir,
    Directory appDocDir,
    Directory appSupportDir,
    Directory externalDir,
  })
>
_getStorageInfo() async {
  // 1. Get Directory Paths
  Directory tempDir = await getTemporaryDirectory();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory appSupportDir = await getApplicationSupportDirectory();
  Directory? externalDir = await getExternalStorageDirectory(); // Android only

  /* 2. Get Space Information (returns values in MB)
  double freeSpace = await StorageInfo.getFreeDiskSpace;
  double totalSpace = await StorageInfo.getTotalDiskSpace;
  */

  developer.log('Documents Path: <${appDocDir.path}>');
  developer.log('Temp Path: ${tempDir.path}>');
  developer.log('Support Path: ${appSupportDir.path}>');
  developer.log('External Path: ${externalDir!.path}>');
  /*
  print('Free Space: $freeSpace MB');
  print('Total Space: $totalSpace MB');
  print('Usage: ${(1 - (freeSpace / totalSpace)) * 100}%');
*/
  return (
    tempDir: tempDir,
    appDocDir: appDocDir,
    appSupportDir: appSupportDir,
    externalDir: externalDir,
  );
}

class MenuItemListUnderDirectory extends StatelessWidget {
  const MenuItemListUnderDirectory({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarForStdFunctional(context, functionalTitle),
      body: Container(
        margin: EdgeInsets.all(20),
        child:
            FutureBuilder<
              ({
                Directory tempDir,
                Directory appDocDir,
                Directory appSupportDir,
                Directory externalDir,
              })
            >(
              future: _getStorageInfo(),
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
                  const int lenToExtract = 25;
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          '''tempDir is <${retRec.tempDir.path.takeLast(lenToExtract)}>
appDocDir is <${retRec.appDocDir.path.takeLast(lenToExtract)}>
appSupportDir is <${retRec.appSupportDir.path.takeLast(lenToExtract)}>
externalDir is <${retRec.externalDir.path.takeLast(lenToExtract)}>''',
                        ),
                      ),
                      Scrollbar(
                        // vertical scrollbar
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Scrollbar(
                            // Horizontal Scrollbar
                            thumbVisibility: true,
                            notificationPredicate: (notif) =>
                                notif.depth ==
                                1, // targets the horizontal scroll
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  '''tempDir is <${retRec.tempDir.path.takeLast(lenToExtract)}>
appDocDir is <${retRec.appDocDir.path.takeLast(lenToExtract)}>
appSupportDir is <${retRec.appSupportDir.path.takeLast(lenToExtract)}>
externalDir is <${retRec.externalDir.path.takeLast(lenToExtract)}>
longContent-todo
longContent-todo 1111111111111111 22222222222222 33333333333333333333 4444444444444444444444
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo 1111111111111111 22222222222222 33333333333333333333 4444444444444444444444
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo 1111111111111111 22222222222222 33333333333333333333 4444444444444444444444
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo 1111111111111111 22222222222222 33333333333333333333 4444444444444444444444
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo 1111111111111111 22222222222222 33333333333333333333 4444444444444444444444
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo
longContent-todo''',
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 12,
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
