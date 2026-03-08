class Order {
  final String id;
  final String customerId;
  List<OrderItem> items;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double discount;
  final double tax;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? confirmedAt;

  Order({
    required this.id,
    required this.customerId,
    required this.items,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.unpaid,
    required this.paymentMethod,
    required this.subtotal,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
    DateTime? createdAt,
    this.updatedAt,
    this.confirmedAt,
  })  : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod.name,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
        orElse: () => PaymentStatus.unpaid,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      subtotal: json['subtotal'].toDouble(),
      discount: json['discount'].toDouble(),
      tax: json['tax'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      confirmedAt: json['confirmedAt'] != null ? DateTime.parse(json['confirmedAt']) : null,
    );
  }

  Order copyWith({
    String? customerId,
    List<OrderItem>? items,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    double? subtotal,
    double? discount,
    double? tax,
    double? totalAmount,
    DateTime? updatedAt,
    DateTime? confirmedAt,
  }) {
    return Order(
      id: id,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String unit;
  final int quantity;
  final double unitPrice;
  final double discount;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
  });

  double get subtotal => (unitPrice * quantity) - discount;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'unit': unit,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      unit: json['unit'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      discount: json['discount'].toDouble(),
    );
  }
}

enum OrderStatus {
  pending,
  confirmed,
  cancelled,
  failed,
}

enum PaymentStatus {
  paid,
  unpaid,
}

enum PaymentMethod {
  cash,
  card,
  gateway,
}
