// ARCHITECTURE DECISION: Immutable data modeling using core Dart features.
// Features copyWith for immutable updates and helper get/is properties for business logic.
// Includes toMap/fromMap serialization ready for future Firebase Cloud Firestore integration.

class PantryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final double lowStockThreshold;
  final DateTime updatedAt;

  const PantryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.lowStockThreshold,
    required this.updatedAt,
  });

  // Helper property to compute if an item is running low
  bool get isLowStock => quantity <= lowStockThreshold;

  PantryItem copyWith({
    String? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    double? lowStockThreshold,
    DateTime? updatedAt,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Firebase-ready serialization methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'lowStockThreshold': lowStockThreshold,
      // Firestore timestamps are typically saved as millisecondsSinceEpoch or FieldValue.serverTimestamp()
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory PantryItem.fromMap(Map<String, dynamic> map, String documentId) {
    return PantryItem(
      id: documentId,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? 'Other',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] as String? ?? 'pcs',
      lowStockThreshold: (map['lowStockThreshold'] as num?)?.toDouble() ?? 1.0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : DateTime.now(),
    );
  }
}
