import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('interview_prep.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    // Print the exact path so the user can easily find it!
    print('=============================================');
    print('DATABASE IS LOCATED EXACTLY AT:');
    print(path);
    print('=============================================');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        email $textType,
        name $textType,
        password_hash $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE interviews (
        id $idType,
        userId $textType,
        type $textType,
        difficulty $textType,
        industry $textType,
        date $textType,
        score $intType,
        details $textType
      )
    ''');
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> registerUser(String name, String email, String password) async {
    final db = await instance.database;
    
    // Check if user exists
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) return null;

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );

    await db.insert('users', {
      ...user.toMap(),
      'password_hash': _hashPassword(password),
    });
    
    return user;
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await instance.database;
    final hash = _hashPassword(password);
    
    final maps = await db.query(
      'users',
      columns: ['id', 'email', 'name'],
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email, hash],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<void> saveInterviewMetrics(String userId, String interviewId, String type, String difficulty, String industry, int score, String detailsStr) async {
    final db = await instance.database;
    await db.insert('interviews', {
      'id': interviewId,
      'userId': userId,
      'type': type,
      'difficulty': difficulty,
      'industry': industry,
      'date': DateTime.now().toIso8601String(),
      'score': score,
      'details': detailsStr, // Could be json encoded feedback
    });
  }
}
