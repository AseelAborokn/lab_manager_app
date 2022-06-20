import 'dart:io';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:external_path/external_path.dart';

/// FileSystem Service - responsible for saving the usage history to csv on the external storage.
class FileSystemService {

  static Future<String> get _localPath async {
    final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    return path;
  }

  /// Create an empty csv file with the current time as a suffix with the following format
  /// [filename] - the filename desired.
  /// it will create the following file: <filename>-yyyy-MM-dd-kk-mm-ss.csv
  static Future<File> createEmptyCSVFile(String filename) async {
    final path = await _localPath;
    print('CSV FilePath: $path/$filename-${DateFormat('yyyy-MM-dd-kk-mm-ss').format(DateTime.now())}.csv');
    return File('$path/$filename-${DateFormat('yyyy-MM-dd-kk-mm-ss').format(DateTime.now())}.csv').create();
  }

  static Future<String> getPathToCSVFile(String filename) async {
    final path = await _localPath;
    return '$path/$filename.csv';
  }

  /// Writes the [header] to the given [csvFile].
  static Future<void> writeCSVHeaderToFile(File csvFile, List<List<String>> header) async {
    String csvHeaders = const ListToCsvConverter().convert(header);
    await csvFile.writeAsString(csvHeaders);
  }

  /// Writes the [data] of rows to the given [csvFile].
  static Future<void> writeCSVDataToFile(File csvFile, List<List<String>> data) async {
    String csvContent = const ListToCsvConverter().convert(data);
    await csvFile.writeAsString(csvContent);
  }
}