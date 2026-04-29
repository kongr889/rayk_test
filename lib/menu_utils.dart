import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class _LogFileOutput extends LogOutput {
  bool _fileResetFlag = false;

  @override
  void output(OutputEvent event) async {
    final directory = await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final filePath = '${directory.path}/sa_menu.log';
    final file = File(filePath);

    if (!_fileResetFlag) {
      if (file.existsSync()) {
        file.deleteSync();
        _fileResetFlag = true;
      }
    }

    for (var line in event.lines) {
      await file.writeAsString('$line\n', mode: FileMode.append);
    }
  }
}

final logger = Logger(
  printer: PrettyPrinter(dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
  output: MultiOutput([
    ConsoleOutput(), // still see logs in IDE debug-console
    _LogFileOutput(), // also save to file
  ]),
);

extension StringExtension on String {
  String takeLast(int n) {
    if (length <= n) return this;
    return substring(length - n);
  }
}
