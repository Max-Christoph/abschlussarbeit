class InventoryItem {
  final String barcode;
  final String productName;
  final DateTime expiryDate;
  final String notes;
  final DateTime addedDate;

  InventoryItem({
    required this.barcode,
    required this.productName,
    required this.expiryDate,
    required this.notes,
    required this.addedDate,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      barcode: json['barcode'],
      productName: json['product_name'],
      expiryDate: DateTime.parse(json['expiry_date']),
      notes: json['notes'] ?? '',
      addedDate: DateTime.parse(json['added_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'product_name': productName,
      'expiry_date': expiryDate.toIso8601String(),
      'notes': notes,
      'added_date': addedDate.toIso8601String(),
    };
  }
} 