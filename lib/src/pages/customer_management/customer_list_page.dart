import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/storage_service.dart';
import 'add_customer_page.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final StorageService _storageService = StorageService();
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  CustomerType? _selectedType;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCustomers() {
    _storageService.initializeDemoData();
    setState(() {
      _customers = _storageService.getAllCustomers();
      _filteredCustomers = _customers;
    });
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = _customers.where((customer) {
        final matchesSearch = query.isEmpty || 
            customer.name.toLowerCase().contains(query) ||
            customer.mobileNumber.toLowerCase().contains(query);
        
        final matchesType = _selectedType == null || customer.type == _selectedType;
        
        return matchesSearch && matchesType;
      }).toList();
    });
  }

  double get _totalReceivable {
    return _filteredCustomers
        .where((c) => c.type == CustomerType.customer)
        .fold(0.0, (sum, customer) => sum + customer.currentDue);
  }

  double get _totalPayable {
    return _filteredCustomers
        .where((c) => c.type == CustomerType.supplier)
        .fold(0.0, (sum, customer) => sum + customer.currentDue.abs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Customer/Supplier Management'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomerSearchDelegate(_customers),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Receivable',
                    '৳${_totalReceivable.toStringAsFixed(2)}',
                    Icons.arrow_downward,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Payable',
                    '৳${_totalPayable.toStringAsFixed(2)}',
                    Icons.arrow_upward,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ),
          
          // Search and Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search customers...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Type Filter
                Row(
                  children: [
                    const Text('Filter by Type: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<CustomerType?>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Types'),
                          ),
                          ...CustomerType.values.map((type) => DropdownMenuItem(
                            value: type,
                            child: Row(
                              children: [
                                Icon(
                                  type == CustomerType.customer
                                      ? Icons.person
                                      : Icons.business,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(type == CustomerType.customer
                                    ? 'Customer'
                                    : 'Supplier'),
                              ],
                            ),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                          _filterCustomers();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Customer List
          Expanded(
            child: _filteredCustomers.isEmpty
                ? _buildEmptyState()
                : _buildCustomersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCustomer,
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add, color: Colors.white),
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
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty || _selectedType != null
                ? 'No customers found'
                : 'No customers added yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          if (_searchController.text.isEmpty && _selectedType == null) ...[
            const SizedBox(height: 8),
            Text(
              'Tap + button to add your first customer',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomersList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = _filteredCustomers[index];
        return _buildCustomerCard(customer);
      },
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: customer.type == CustomerType.customer
              ? Colors.blue[100]
              : Colors.orange[100],
          child: Icon(
            customer.type == CustomerType.customer
                ? Icons.person
                : Icons.business,
            color: customer.type == CustomerType.customer
                ? Colors.blue[800]
                : Colors.orange[800],
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.mobileNumber),
            Text(
              customer.type == CustomerType.customer ? 'Customer' : 'Supplier',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '৳${customer.currentDue.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: customer.currentDue >= 0 ? Colors.green : Colors.red,
              ),
            ),
            Text(
              customer.currentDue >= 0 ? 'To Receive' : 'To Pay',
              style: TextStyle(
                fontSize: 12,
                color: customer.currentDue >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        onTap: () => _navigateToCustomerDetails(customer),
      ),
    );
  }

  void _navigateToAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCustomerPage()),
    );
    if (result == true) {
      _loadCustomers();
    }
  }

  void _navigateToCustomerDetails(Customer customer) {
    // TODO: Navigate to customer details page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Customer details for ${customer.name} coming soon!'),
      ),
    );
  }
}

class CustomerSearchDelegate extends SearchDelegate<Customer?> {
  final List<Customer> customers;

  CustomerSearchDelegate(this.customers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = customers.where((customer) =>
      customer.name.toLowerCase().contains(query.toLowerCase()) ||
      customer.mobileNumber.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final customer = results[index];
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.mobileNumber),
          trailing: Text('৳${customer.currentDue.toStringAsFixed(2)}'),
          onTap: () => close(context, customer),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = customers.where((customer) =>
      customer.name.toLowerCase().contains(query.toLowerCase()) ||
      customer.mobileNumber.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final customer = suggestions[index];
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.mobileNumber),
          trailing: Text('৳${customer.currentDue.toStringAsFixed(2)}'),
          onTap: () => close(context, customer),
        );
      },
    );
  }
}
