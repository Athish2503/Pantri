// ARCHITECTURE DECISION: Domain-driven Family model representing collaborative household groups.
// Contains unique invite codes and member lists to enforce granular security rules and real-time query constraints.

class Family {
  final String id;
  final String name;
  final String inviteCode;
  final List<String> memberIds;
  final DateTime createdAt;

  const Family({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.memberIds,
    required this.createdAt,
  });

  Family copyWith({
    String? id,
    String? name,
    String? inviteCode,
    List<String>? memberIds,
    DateTime? createdAt,
  }) {
    return Family(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'inviteCode': inviteCode,
      'memberIds': memberIds,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Family.fromMap(Map<String, dynamic> map, String documentId) {
    return Family(
      id: documentId,
      name: map['name'] as String? ?? 'Our Household',
      inviteCode: map['inviteCode'] as String? ?? '',
      memberIds: List<String>.from(map['memberIds'] as List? ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
    );
  }
}
