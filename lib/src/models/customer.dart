class Customer {
  final String id;
  String name;
  String mobileNumber;
  final CustomerType type;
  double openingBalance;
  final DateTime openingBalanceDate;
  String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.type,
    this.openingBalance = 0.0,
    DateTime? openingBalanceDate,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : openingBalanceDate = openingBalanceDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  double get currentDue {
    // This would be calculated from transactions in a real app
    return openingBalance;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'type': type.name,
      'openingBalance': openingBalance,
      'openingBalanceDate': openingBalanceDate.toIso8601String(),
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      type: CustomerType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CustomerType.customer,
      ),
      openingBalance: json['openingBalance'].toDouble(),
      openingBalanceDate: DateTime.parse(json['openingBalanceDate']),
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Customer copyWith({
    String? name,
    String? mobileNumber,
    CustomerType? type,
    double? openingBalance,
    String? imageUrl,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      type: type ?? this.type,
      openingBalance: openingBalance ?? this.openingBalance,
      openingBalanceDate: openingBalanceDate,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

enum CustomerType {
  customer,
  supplier,
}
