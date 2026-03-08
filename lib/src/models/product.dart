class Product {
  final String id;
  String name;
  String unit;
  double price;
  int quantity;
  String? description;
  String? productCode;
  String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    this.quantity = 0,
    this.description,
    this.productCode,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  double get totalValue => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'price': price,
      'quantity': quantity,
      'description': description,
      'productCode': productCode,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      description: json['description'],
      productCode: json['productCode'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Product copyWith({
    String? name,
    String? unit,
    double? price,
    int? quantity,
    String? description,
    String? productCode,
    String? imageUrl,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      productCode: productCode ?? this.productCode,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class StockMovement {
  final String id;
  final String productId;
  final int quantity;
  final StockMovementType type;
  final String? note;
  final DateTime createdAt;

  StockMovement({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.type,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'type': type.name,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      type: StockMovementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StockMovementType.stockIn,
      ),
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

enum StockMovementType {
  stockIn,
  stockOut,
}
