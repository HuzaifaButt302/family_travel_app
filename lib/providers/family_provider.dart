import 'package:flutter/material.dart';
import '../models/member_model.dart';
import '../models/document_model.dart';
import '../database/database_helper.dart';

class FamilyProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<FamilyMember> _members = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<FamilyMember> get members {
    if (_searchQuery.isEmpty) {
      return _members;
    }
    return _members.where((member) {
      return member.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             member.relation.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<FamilyMember> get allMembers => _members;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Initialize provider - load data from database
  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _members = await _dbHelper.getAllMembers();
    } catch (e) {
      debugPrint('Error loading data: $e');
      _members = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search functionality
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Member add karne ke liye
  Future<bool> addMember(FamilyMember member) async {
    try {
      await _dbHelper.insertMember(member);
      _members.add(member);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding member: $e');
      return false;
    }
  }

  // Member update karne ke liye
  Future<bool> updateMember(FamilyMember member) async {
    try {
      await _dbHelper.updateMember(member);
      int index = _members.indexWhere((m) => m.id == member.id);
      if (index != -1) {
        _members[index] = member;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error updating member: $e');
      return false;
    }
  }

  // Member delete karne ke liye
  Future<bool> deleteMember(String memberId) async {
    try {
      await _dbHelper.deleteMember(memberId);
      _members.removeWhere((member) => member.id == memberId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting member: $e');
      return false;
    }
  }

  // Member ke andar document add karne ke liye
  Future<bool> addDocumentToMember(String memberId, AppDocument doc) async {
    try {
      await _dbHelper.insertDocument(memberId, doc);
      int memberIndex = _members.indexWhere((m) => m.id == memberId);
      if (memberIndex != -1) {
        _members[memberIndex].documents.add(doc);
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error adding document: $e');
      return false;
    }
  }

  // Document update karne ke liye
  Future<bool> updateDocument(String memberId, AppDocument document) async {
    try {
      await _dbHelper.updateDocument(document);
      int memberIndex = _members.indexWhere((m) => m.id == memberId);
      if (memberIndex != -1) {
        int docIndex = _members[memberIndex].documents.indexWhere((d) => d.id == document.id);
        if (docIndex != -1) {
          _members[memberIndex].documents[docIndex] = document;
          notifyListeners();
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error updating document: $e');
      return false;
    }
  }

  // Document delete karne ke liye
  Future<bool> deleteDocument(String memberId, String documentId) async {
    try {
      await _dbHelper.deleteDocument(documentId);
      int memberIndex = _members.indexWhere((m) => m.id == memberId);
      if (memberIndex != -1) {
        _members[memberIndex].documents.removeWhere((doc) => doc.id == documentId);
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting document: $e');
      return false;
    }
  }

  // Refresh data from database
  Future<void> refreshData() async {
    await initializeData();
  }

  // Statistics ke liye methods
  int get totalMembers => _members.length;
  int get totalDocuments => _members.fold(0, (sum, member) => sum + member.documentsCount);
  int get totalExpiredDocuments => _members.fold(0, (sum, member) => sum + member.expiredDocumentsCount);
  int get totalExpiringSoonDocuments => _members.fold(0, (sum, member) => sum + member.expiringSoonCount);

  // Get members with expired documents
  List<FamilyMember> get membersWithExpiredDocs {
    return _members.where((member) => member.expiredDocumentsCount > 0).toList();
  }

  // Get members with expiring soon documents
  List<FamilyMember> get membersWithExpiringSoonDocs {
    return _members.where((member) => member.expiringSoonCount > 0).toList();
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    try {
      await _dbHelper.clearDatabase();
      _members.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }
}
