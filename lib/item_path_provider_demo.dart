import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
//import 'package:storage_info/storage_info.dart';
import 'menu_base.dart';

Future<(Directory, Directory, Directory, Directory)> _getStorageInfo() async {
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
  return (tempDir, appDocDir, appSupportDir, externalDir);
}

class MenuItemPathProviderDemo extends StatelessWidget {
  const MenuItemPathProviderDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarForStdFunctional(context, functionalTitle),
      body: Container(
        margin: EdgeInsets.all(20),
        child: FutureBuilder<(Directory, Directory, Directory, Directory)>(
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
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('''${snapshot.data}'''),
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
