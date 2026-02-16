import 'dart:io';

class AppDocument {
  final String id;
  final String name;
  final DateTime issueDate;
  final DateTime expiryDate;
  final File? imageFile;

  AppDocument({
    required this.id,
    required this.name,
    required this.issueDate,
    required this.expiryDate,
    this.imageFile,
  });

  // Days remaining until expiry
  int get daysRemaining {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  // Check if document is expired
  bool get isExpired => daysRemaining < 0;

  // Check if document is expiring soon (within 6 months)
  bool get isExpiringSoon => daysRemaining >= 0 && daysRemaining <= 180;

  // Check if document is valid (more than 6 months)
  bool get isValid => daysRemaining > 180;

  // Expiry status calculate karne ke liye
  String getExpiryStatus() {
    if (isExpired) {
      return 'EXPIRED'; // Red badge
    } else if (isExpiringSoon) {
      return 'EXPIRING SOON'; // Yellow badge
    } else {
      return 'VALID'; // Green badge
    }
  }

  // Human readable expiry message
  String getExpiryMessage() {
    if (isExpired) {
      return 'Expired ${(-daysRemaining)} days ago';
    } else if (daysRemaining == 0) {
      return 'Expires today';
    } else if (daysRemaining == 1) {
      return 'Expires tomorrow';
    } else if (isExpiringSoon) {
      return 'Expires in $daysRemaining days';
    } else {
      return 'Valid for $daysRemaining days';
    }
  }

  // Badge color get karne ke liye
  int getStatusColor() {
    switch (getExpiryStatus()) {
      case 'EXPIRED':
        return 0xFFE53935; // Red
      case 'EXPIRING SOON':
        return 0xFFFFA726; // Orange/Yellow
      case 'VALID':
        return 0xFF43A047; // Green
      default:
        return 0xFF757575; // Grey
    }
  }

  // Priority for sorting (expired first, then expiring soon, then valid)
  int get priority {
    if (isExpired) return 0;
    if (isExpiringSoon) return 1;
    return 2;
  }
}
