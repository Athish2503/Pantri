// ARCHITECTURE DECISION: Immutable data modeling using core Dart features.
// Features copyWith for immutable updates and helper get/is properties for business logic.
// Includes toMap/fromMap serialization ready for future Firebase Cloud Firestore integration.

enum StockStatus {
  enough,
  low,
  finished,
}

class PantryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final double lowStockThreshold;
  final StockStatus stockStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isRecurring;

  const PantryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.lowStockThreshold,
    required this.stockStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.isRecurring,
  });

  // Helper property to compute if an item is running low based on threshold or status
  bool get isLowStock =>
      quantity <= lowStockThreshold ||
      stockStatus == StockStatus.low ||
      stockStatus == StockStatus.finished;

  PantryItem copyWith({
    String? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    double? lowStockThreshold,
    StockStatus? stockStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRecurring,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      stockStatus: stockStatus ?? this.stockStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRecurring: isRecurring ?? this.isRecurring,
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
      'stockStatus': stockStatus.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isRecurring': isRecurring,
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
      stockStatus: StockStatus.values.firstWhere(
        (e) => e.name == map['stockStatus'],
        orElse: () => StockStatus.enough,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : DateTime.now(),
      isRecurring: map['isRecurring'] as bool? ?? false,
    );
  }
}
