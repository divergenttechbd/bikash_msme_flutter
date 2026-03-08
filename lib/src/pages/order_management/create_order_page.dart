import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../models/customer.dart';
import '../../services/storage_service.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  
  Customer? _selectedCustomer;
  List<OrderItem> _orderItems = [];
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  double _discount = 0.0;
  double _tax = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _storageService.initializeDemoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Create Order'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Selection
                    _buildSectionCard('Select Customer', [
                      DropdownButtonFormField<Customer>(
                        value: _selectedCustomer,
                        decoration: const InputDecoration(
                          labelText: 'Customer *',
                          border: OutlineInputBorder(),
                        ),
                        items: _storageService.getAllCustomers()
                            .map((customer) => DropdownMenuItem(
                                  value: customer,
                                  child: Row(
                                    children: [
                                      Icon(
                                        customer.type == CustomerType.customer
                                            ? Icons.person
                                            : Icons.business,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 4,
                                        children: [
                                          Text(
                                            customer.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12.6,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            "(${customer.mobileNumber})",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCustomer = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a customer';
                          }
                          return null;
                        },
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Order Items
                    _buildSectionCard('Order Items', [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _addOrderItem,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_orderItems.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('No products added yet'),
                          ),
                        )
                      else
                        ..._orderItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return _buildOrderItemCard(item, index);
                        }).toList(),
                    ]),

                    const SizedBox(height: 16),

                    // Payment Method
                    _buildSectionCard('Payment Method', [
                      DropdownButtonFormField<PaymentMethod>(
                        value: _selectedPaymentMethod,
                        decoration: const InputDecoration(
                          labelText: 'Payment Method *',
                          border: OutlineInputBorder(),
                        ),
                        items: PaymentMethod.values.map((method) => DropdownMenuItem(
                          value: method,
                          child: Row(
                            children: [
                              Icon(_getPaymentIcon(method), size: 20),
                              const SizedBox(width: 8),
                              Text(_getPaymentText(method)),
                            ],
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Order Summary
                    _buildOrderSummary(),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Order'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeOrderItem(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity: ${item.quantity} ${item.unit}'),
              Text('Price: ৳${item.unitPrice.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Subtotal: ৳${item.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final subtotal = _orderItems.fold(0.0, (sum, item) => sum + item.subtotal);
    final total = subtotal - _discount + _tax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:'),
                Text('৳${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            if (_discount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discount:'),
                  Text('-৳${_discount.toStringAsFixed(2)}'),
                ],
              ),
            ],
            if (_tax > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tax:'),
                  Text('৳${_tax.toStringAsFixed(2)}'),
                ],
              ),
            ],
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '৳${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addOrderItem() async {
    final products = _storageService.getAllProducts();
    if (products.isEmpty) {
      _showErrorDialog('No products available. Please add products first.');
      return;
    }

    final result = await showDialog<OrderItem>(
      context: context,
      builder: (context) => AddProductDialog(products: products),
    );

    if (result != null) {
      setState(() {
        _orderItems.add(result);
      });
    }
  }

  void _removeOrderItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }

  void _createOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_orderItems.isEmpty) {
      _showErrorDialog('Please add at least one product to the order.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final subtotal = _orderItems.fold(0.0, (sum, item) => sum + item.subtotal);
      final total = subtotal - _discount + _tax;

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: _selectedCustomer!.id,
        items: _orderItems,
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.unpaid,
        paymentMethod: _selectedPaymentMethod,
        subtotal: subtotal,
        discount: _discount,
        tax: _tax,
        totalAmount: total,
      );

      _storageService.addOrder(order);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showErrorDialog('Failed to create order. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.gateway:
        return Icons.account_balance;
    }
  }

  String _getPaymentText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.gateway:
        return 'Payment Gateway';
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final List<Product> products;

  const AddProductDialog({super.key, required this.products});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  Product? _selectedProduct;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
              decoration: const InputDecoration(
                labelText: 'Product *',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              isDense: true,
              items: widget.products.map((product) => DropdownMenuItem(
                value: product,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900],
                      ),
                    ),
                    Text(
                      '(${product.quantity} ${product.unit} | ৳${product.price.toStringAsFixed(2)})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity *',
                border: const OutlineInputBorder(),
                suffixText: _selectedProduct?.unit ?? '',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Quantity is required';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Please enter a valid quantity';
                }
                if (_selectedProduct != null && quantity > _selectedProduct!.quantity) {
                  return 'Insufficient stock. Available: ${_selectedProduct!.quantity}';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Validate inputs before proceeding
            if (_selectedProduct == null) {
              return;
            }
            
            final quantityText = _quantityController.text.trim();
            if (quantityText.isEmpty) {
              return;
            }
            
            final quantity = int.tryParse(quantityText);
            if (quantity == null || quantity <= 0) {
              return;
            }
            
            if (quantity > _selectedProduct!.quantity) {
              return;
            }
            
            // All validations passed, create order item
            final orderItem = OrderItem(
              productId: _selectedProduct!.id,
              productName: _selectedProduct!.name,
              unit: _selectedProduct!.unit,
              quantity: quantity,
              unitPrice: _selectedProduct!.price,
            );
            Navigator.pop(context, orderItem);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
