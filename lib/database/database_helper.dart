import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member_model.dart';
import '../models/document_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'family_travel.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Family Members table
    await db.execute('''
      CREATE TABLE members (
        id TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        age INTEGER NOT NULL,
        relation TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Documents table
    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        memberId TEXT NOT NULL,
        name TEXT NOT NULL,
        issueDate TEXT NOT NULL,
        expiryDate TEXT NOT NULL,
        imagePath TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (memberId) REFERENCES members (id) ON DELETE CASCADE
      )
    ''');
  }

  // ============ MEMBER OPERATIONS ============

  Future<int> insertMember(FamilyMember member) async {
    final db = await database;

    final memberMap = {
      'id': member.id,
      'fullName': member.fullName,
      'age': member.age,
      'relation': member.relation,
      'createdAt': DateTime.now().toIso8601String(),
    };

    return await db.insert('members', memberMap);
  }

  Future<List<FamilyMember>> getAllMembers() async {
    final db = await database;

    final List<Map<String, dynamic>> memberMaps = await db.query('members');

    List<FamilyMember> members = [];

    for (var memberMap in memberMaps) {
      // Get documents for this member
      final List<AppDocument> documents = await getDocumentsByMemberId(memberMap['id']);

      final member = FamilyMember(
        id: memberMap['id'],
        fullName: memberMap['fullName'],
        age: memberMap['age'],
        relation: memberMap['relation'],
        documents: documents,
      );

      members.add(member);
    }

    return members;
  }

  Future<FamilyMember?> getMemberById(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final memberMap = maps.first;
    final List<AppDocument> documents = await getDocumentsByMemberId(id);

    return FamilyMember(
      id: memberMap['id'],
      fullName: memberMap['fullName'],
      age: memberMap['age'],
      relation: memberMap['relation'],
      documents: documents,
    );
  }

  Future<int> updateMember(FamilyMember member) async {
    final db = await database;

    final memberMap = {
      'fullName': member.fullName,
      'age': member.age,
      'relation': member.relation,
    };

    return await db.update(
      'members',
      memberMap,
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  Future<int> deleteMember(String id) async {
    final db = await database;

    // Delete member's documents first
    await deleteDocumentsByMemberId(id);

    return await db.delete(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============ DOCUMENT OPERATIONS ============

  Future<int> insertDocument(String memberId, AppDocument document) async {
    final db = await database;

    final documentMap = {
      'id': document.id,
      'memberId': memberId,
      'name': document.name,
      'issueDate': document.issueDate.toIso8601String(),
      'expiryDate': document.expiryDate.toIso8601String(),
      'imagePath': document.imageFile?.path,
      'createdAt': DateTime.now().toIso8601String(),
    };

    return await db.insert('documents', documentMap);
  }

  Future<List<AppDocument>> getDocumentsByMemberId(String memberId) async {
    final db = await database;

    final List<Map<String, dynamic>> documentMaps = await db.query(
      'documents',
      where: 'memberId = ?',
      whereArgs: [memberId],
    );

    return documentMaps.map((map) {
      File? imageFile;
      if (map['imagePath'] != null && map['imagePath'].toString().isNotEmpty) {
        imageFile = File(map['imagePath']);
        // Check if file still exists
        if (!imageFile.existsSync()) {
          imageFile = null;
        }
      }

      return AppDocument(
        id: map['id'],
        name: map['name'],
        issueDate: DateTime.parse(map['issueDate']),
        expiryDate: DateTime.parse(map['expiryDate']),
        imageFile: imageFile,
      );
    }).toList();
  }

  Future<List<AppDocument>> getAllDocuments() async {
    final db = await database;

    final List<Map<String, dynamic>> documentMaps = await db.query('documents');

    return documentMaps.map((map) {
      File? imageFile;
      if (map['imagePath'] != null && map['imagePath'].toString().isNotEmpty) {
        imageFile = File(map['imagePath']);
        if (!imageFile.existsSync()) {
          imageFile = null;
        }
      }

      return AppDocument(
        id: map['id'],
        name: map['name'],
        issueDate: DateTime.parse(map['issueDate']),
        expiryDate: DateTime.parse(map['expiryDate']),
        imageFile: imageFile,
      );
    }).toList();
  }

  Future<int> updateDocument(AppDocument document) async {
    final db = await database;

    final documentMap = {
      'name': document.name,
      'issueDate': document.issueDate.toIso8601String(),
      'expiryDate': document.expiryDate.toIso8601String(),
      'imagePath': document.imageFile?.path,
    };

    return await db.update(
      'documents',
      documentMap,
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }

  Future<int> deleteDocument(String documentId) async {
    final db = await database;

    return await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [documentId],
    );
  }

  Future<int> deleteDocumentsByMemberId(String memberId) async {
    final db = await database;

    return await db.delete(
      'documents',
      where: 'memberId = ?',
      whereArgs: [memberId],
    );
  }

  // ============ UTILITY OPERATIONS ============

  Future<int> getTotalMembersCount() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM members'
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalDocumentsCount() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM documents'
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getExpiryStatistics() async {
    final db = await database;

    final now = DateTime.now();
    final expiringSoonDate = now.add(const Duration(days: 180));

    // Get expired documents count
    final expiredResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM documents WHERE expiryDate < ?',
      [now.toIso8601String()]
    );

    // Get expiring soon documents count
    final expiringSoonResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM documents WHERE expiryDate >= ? AND expiryDate <= ?',
      [now.toIso8601String(), expiringSoonDate.toIso8601String()]
    );

    // Get valid documents count
    final validResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM documents WHERE expiryDate > ?',
      [expiringSoonDate.toIso8601String()]
    );

    return [
      {'type': 'expired', 'count': Sqflite.firstIntValue(expiredResult) ?? 0},
      {'type': 'expiring_soon', 'count': Sqflite.firstIntValue(expiringSoonResult) ?? 0},
      {'type': 'valid', 'count': Sqflite.firstIntValue(validResult) ?? 0},
    ];
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('documents');
    await db.delete('members');
  }
}
