import 'package:flutter/material.dart';
// import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
//import 'package:storage_info/storage_info.dart';
import 'package:permission_handler/permission_handler.dart';
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
    Directory? externalDir,
    Directory downloadDir,
    Directory pictureDir,
    Directory cameraDir,
    Directory? dirToList,
    String permissionOnDir,
    List<FileSystemEntity> fileList,
    int fileCount,
  })
>
_getStorageInfo() async {
  // 1. Get Directory Paths
  Directory tempDir = await getTemporaryDirectory();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory appSupportDir = await getApplicationSupportDirectory();
  Directory? externalDir = await getExternalStorageDirectory(); // Android only
  Directory downloadDir = Directory('/storage/emulated/0/Download');
  Directory pictureDir = Directory('/storage/emulated/0/Pictures');
  Directory dcimDir = Directory('/storage/emulated/0/DCIM');

  /* 2. Get Space Information (returns values in MB)
  double freeSpace = await StorageInfo.getFreeDiskSpace;
  double totalSpace = await StorageInfo.getTotalDiskSpace;
  */

  // As a workaround, the following make sure externalDir is not null.
  // todo: should change it to a more professional way.
  // developer.log('External Path: ${externalDir!.path}>');

  /*
  print('Free Space: $freeSpace MB');
  print('Total Space: $totalSpace MB');
  print('Usage: ${(1 - (freeSpace / totalSpace)) * 100}%');
*/

  Directory dirToList = dcimDir;
  // Directory dirToList = tempDir.parent.parent;

  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied) {
    status = await Permission.manageExternalStorage.request();
  }
  String permissionOnDir = '';
  if (status.isGranted) {
    permissionOnDir = 'Full storage access granted';
  } else {
    permissionOnDir = 'Full storage access denied';
  }

  List<FileSystemEntity> fileList = await dirToList
      .list(recursive: true)
      .toList();
  int fileCount = fileList.length;

  return (
    tempDir: tempDir,
    appDocDir: appDocDir,
    appSupportDir: appSupportDir,
    externalDir: externalDir,
    downloadDir: downloadDir,
    pictureDir: pictureDir,
    cameraDir: dcimDir,
    dirToList: dirToList,
    permissionOnDir: permissionOnDir,
    fileList: fileList,
    fileCount: fileCount,
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
                Directory? externalDir,
                Directory downloadDir,
                Directory pictureDir,
                Directory cameraDir,
                Directory? dirToList,
                String permissionOnDir,
                List<FileSystemEntity> fileList,
                int fileCount,
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
                                  notif.depth ==
                                  1, // targets the horizontal scroll
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
