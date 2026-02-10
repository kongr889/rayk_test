import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'sqflite_demo.db');
    final database = await openDatabase(databasePath);
  }
}
