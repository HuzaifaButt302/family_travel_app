import 'document_model.dart';

class FamilyMember {
  final String id;
  final String fullName;
  final int age;
  final String relation;
  final List<AppDocument> documents;

  FamilyMember({
    required this.id,
    required this.fullName,
    required this.age,
    required this.relation,
    List<AppDocument>? documents,
  }) : documents = documents ?? [];

  // Documents count get karne ke liye
  int get documentsCount => documents.length;

  // Expired documents count
  int get expiredDocumentsCount =>
      documents.where((doc) => doc.isExpired).length;

  // Expiring soon documents count
  int get expiringSoonCount =>
      documents.where((doc) => doc.isExpiringSoon).length;

  // Valid documents count
  int get validDocumentsCount =>
      documents.where((doc) => doc.isValid).length;

  // Get sorted documents (expired first, then expiring soon, then valid)
  List<AppDocument> get sortedDocuments {
    List<AppDocument> sorted = List.from(documents);
    sorted.sort((a, b) {
      // First sort by priority (expired, expiring, valid)
      int priorityComparison = a.priority.compareTo(b.priority);
      if (priorityComparison != 0) return priorityComparison;

      // If same priority, sort by days remaining (ascending)
      return a.daysRemaining.compareTo(b.daysRemaining);
    });
    return sorted;
  }

  // Check if member has any critical documents (expired or expiring soon)
  bool get hasCriticalDocuments => expiredDocumentsCount > 0 || expiringSoonCount > 0;

  // Get the most critical document (if any)
  AppDocument? get mostCriticalDocument {
    if (documents.isEmpty) return null;

    // Find expired documents first
    var expired = documents.where((doc) => doc.isExpired).toList();
    if (expired.isNotEmpty) {
      expired.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
      return expired.first; // Most expired
    }

    // Then find expiring soon documents
    var expiring = documents.where((doc) => doc.isExpiringSoon).toList();
    if (expiring.isNotEmpty) {
      expiring.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
      return expiring.first; // Expiring soonest
    }

    return null;
  }
}
