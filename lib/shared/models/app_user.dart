// ARCHITECTURE DECISION: Domain-driven AppUser model representing authenticated users.
// Stores basic credentials along with an optional linked familyId to enable multi-user household syncing.

class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? familyId;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.familyId,
    required this.createdAt,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? familyId,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      familyId: familyId ?? this.familyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'familyId': familyId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String documentId) {
    return AppUser(
      id: documentId,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      familyId: map['familyId'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
    );
  }
}
