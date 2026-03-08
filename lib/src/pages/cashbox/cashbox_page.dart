import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/customer.dart';
import '../../services/storage_service.dart';

class CashboxPage extends StatefulWidget {
  const CashboxPage({super.key});

  @override
  State<CashboxPage> createState() => _CashboxPageState();
}

class _CashboxPageState extends State<CashboxPage> {
  final StorageService _storageService = StorageService();
  
  // Today's data
  double _todaySales = 0.0;
  double _todayReceivables = 0.0;
  double _todayPayables = 0.0;
  double _currentCashBalance = 0.0;
  bool _showNumbers = true;

  @override
  void initState() {
    super.initState();
    _loadCashboxData();
  }

  void _loadCashboxData() {
    _storageService.initializeDemoData();
    
    // For demo purposes, calculate from orders and customers
    final today = DateTime.now();
    final todayOrders = _storageService.getAllOrders()
        .where((order) => _isSameDay(order.createdAt, today))
        .toList();
    
    final customers = _storageService.getAllCustomers();
    
    setState(() {
      _todaySales = todayOrders
          .where((order) => order.status == OrderStatus.confirmed)
          .fold(0.0, (sum, order) => sum + order.totalAmount);
      
      _todayReceivables = customers
          .where((c) => c.type == CustomerType.customer && c.currentDue > 0)
          .fold(0.0, (sum, customer) => sum + customer.currentDue);
      
      _todayPayables = customers
          .where((c) => c.type == CustomerType.supplier && c.currentDue < 0)
          .fold(0.0, (sum, customer) => sum + customer.currentDue.abs());
      
      _currentCashBalance = 15000.0; // Demo balance
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Cashbox'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: _showReports,
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: _reconcileCashbox,
          ),
        ],
      ),
      body: Column(
        children: [
          // View Toggle
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Show Numbers:'),
                const SizedBox(width: 8),
                Switch(
                  value: _showNumbers,
                  onChanged: (value) {
                    setState(() {
                      _showNumbers = value;
                    });
                  },
                ),
                const Spacer(),
                if (_showNumbers)
                  IconButton(
                    icon: const Icon(Icons.calculate),
                    onPressed: _reconcileCashbox,
                    tooltip: 'Reconcile Cashbox',
                  ),
              ],
            ),
          ),
          
          if (_showNumbers) ...[
            // Summary Cards
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Today\'s Sales',
                          '৳${_todaySales.toStringAsFixed(2)}',
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          'Current Cash Balance',
                          '৳${_currentCashBalance.toStringAsFixed(2)}',
                          Icons.account_balance_wallet,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Today\'s Receivables',
                          '৳${_todayReceivables.toStringAsFixed(2)}',
                          Icons.arrow_downward,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          'Today\'s Payables',
                          '৳${_todayPayables.toStringAsFixed(2)}',
                          Icons.arrow_upward,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          // Quick Actions
          if (_showNumbers) ...[
            Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              'Record Sale',
                              Icons.add_circle,
                              Colors.green,
                              () => _recordTransaction('sale'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              'Record Purchase',
                              Icons.remove_circle,
                              Colors.red,
                              () => _recordTransaction('purchase'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              'Record Expense',
                              Icons.money_off,
                              Colors.orange,
                              () => _recordTransaction('expense'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              'Owner Transaction',
                              Icons.person,
                              Colors.purple,
                              () => _recordTransaction('owner'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  void _recordTransaction(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type recording coming soon!'),
      ),
    );
  }

  void _reconcileCashbox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reconcile Cashbox'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the actual cash amount in cashbox:'),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cash in Cashbox',
                prefixText: '৳ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cashbox reconciliation completed!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Reconcile'),
          ),
        ],
      ),
    );
  }

  void _showReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cashbox reports coming soon!'),
      ),
    );
  }
}
