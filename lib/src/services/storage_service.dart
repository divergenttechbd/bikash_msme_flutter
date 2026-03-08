import '../models/product.dart';
import '../models/order.dart';
import '../models/customer.dart';

class BusinessNote {
  final String id;
  final String content;
  final bool isCompleted;
  final DateTime createdAt;

  BusinessNote({
    required this.id,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BusinessNote.fromJson(Map<String, dynamic> json) {
    return BusinessNote(
      id: json['id'],
      content: json['content'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Map<String, Product> _products = {};
  final Map<String, Order> _orders = {};
  final Map<String, Customer> _customers = {};
  final Map<String, BusinessNote> _businessNotes = {};

  // Initialize with demo data
  void initializeDemoData() {
    if (_products.isEmpty) {
      _addDemoProducts();
    }
    if (_customers.isEmpty) {
      _addDemoCustomers();
    }
    if (_orders.isEmpty) {
      _addDemoOrders();
    }
    if (_businessNotes.isEmpty) {
      _addDemoBusinessNotes();
    }
  }

  void _addDemoProducts() {
    final demoProducts = [
      Product(
        id: '1',
        name: 'Rice',
        unit: 'kg',
        price: 50.0,
        quantity: 100,
        description: 'Premium quality rice',
        productCode: 'R001',
      ),
      Product(
        id: '2',
        name: 'Sugar',
        unit: 'kg',
        price: 45.0,
        quantity: 50,
        description: 'Refined sugar',
        productCode: 'S001',
      ),
      Product(
        id: '3',
        name: 'Cooking Oil',
        unit: 'liter',
        price: 120.0,
        quantity: 25,
        description: 'Pure cooking oil',
        productCode: 'O001',
      ),
      Product(
        id: '4',
        name: 'Flour',
        unit: 'kg',
        price: 40.0,
        quantity: 75,
        description: 'Wheat flour',
        productCode: 'F001',
      ),
    ];

    for (final product in demoProducts) {
      _products[product.id] = product;
    }
  }

  void _addDemoCustomers() {
    final demoCustomers = [
      Customer(
        id: '1',
        name: 'John Doe',
        mobileNumber: '01712345678',
        type: CustomerType.customer,
        openingBalance: 500.0,
      ),
      Customer(
        id: '2',
        name: 'Jane Smith',
        mobileNumber: '01823456789',
        type: CustomerType.customer,
        openingBalance: 300.0,
      ),
      Customer(
        id: '3',
        name: 'ABC Suppliers',
        mobileNumber: '01934567890',
        type: CustomerType.supplier,
        openingBalance: -1000.0,
      ),
    ];

    for (final customer in demoCustomers) {
      _customers[customer.id] = customer;
    }
  }

  void _addDemoOrders() {
    final demoOrders = [
      Order(
        id: '1',
        customerId: '1',
        items: [
          OrderItem(
            productId: '1',
            productName: 'Rice',
            unit: 'kg',
            quantity: 5,
            unitPrice: 50.0,
          ),
          OrderItem(
            productId: '2',
            productName: 'Sugar',
            unit: 'kg',
            quantity: 2,
            unitPrice: 45.0,
          ),
        ],
        status: OrderStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.cash,
        subtotal: 340.0,
        tax: 0.0,
        totalAmount: 340.0,
        confirmedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Order(
        id: '2',
        customerId: '2',
        items: [
          OrderItem(
            productId: '3',
            productName: 'Cooking Oil',
            unit: 'liter',
            quantity: 3,
            unitPrice: 120.0,
          ),
        ],
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.unpaid,
        paymentMethod: PaymentMethod.gateway,
        subtotal: 360.0,
        tax: 0.0,
        totalAmount: 360.0,
      ),
    ];

    for (final order in demoOrders) {
      _orders[order.id] = order;
    }
  }

  // Product operations
  List<Product> getAllProducts() {
    return _products.values.toList();
  }

  Product? getProduct(String id) {
    return _products[id];
  }

  void addProduct(Product product) {
    _products[product.id] = product;
  }

  void updateProduct(Product product) {
    _products[product.id] = product;
  }

  void deleteProduct(String id) {
    _products.remove(id);
  }

  // Order operations
  List<Order> getAllOrders() {
    return _orders.values.toList();
  }

  Order? getOrder(String id) {
    return _orders[id];
  }

  void addOrder(Order order) {
    _orders[order.id] = order;
  }

  void updateOrder(Order order) {
    _orders[order.id] = order;
  }

  void deleteOrder(String id) {
    _orders.remove(id);
  }

  // Customer operations
  List<Customer> getAllCustomers() {
    return _customers.values.toList();
  }

  Customer? getCustomer(String id) {
    return _customers[id];
  }

  void addCustomer(Customer customer) {
    _customers[customer.id] = customer;
  }

  void updateCustomer(Customer customer) {
    _customers[customer.id] = customer;
  }

  void deleteCustomer(String id) {
    _customers.remove(id);
  }

  // Utility methods
  double getTotalStockValue() {
    return _products.values.fold(0.0, (sum, product) => sum + product.totalValue);
  }

  List<String> getAvailableUnits() {
    return ['kg', 'liter', 'piece', 'box', 'dozen', 'packet', 'bottle', 'meter'];
  }

  // Business Notes operations
  List<BusinessNote> getBusinessNotes() {
    return _businessNotes.values.toList();
  }

  void addBusinessNote(BusinessNote note) {
    _businessNotes[note.id] = note;
  }

  void updateBusinessNote(BusinessNote note) {
    _businessNotes[note.id] = note;
  }

  void deleteBusinessNote(String id) {
    _businessNotes.remove(id);
  }

  void _addDemoBusinessNotes() {
    final demoNotes = [
      BusinessNote(
        id: '1',
        content: 'Follow up with wholesale supplier for new stock',
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      BusinessNote(
        id: '2',
        content: 'Prepare monthly sales report for tax filing',
        isCompleted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BusinessNote(
        id: '3',
        content: 'Contact bKash for payment gateway integration',
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
    ];

    for (final note in demoNotes) {
      _businessNotes[note.id] = note;
    }
  }
}
