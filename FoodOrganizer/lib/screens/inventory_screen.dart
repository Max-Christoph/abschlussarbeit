import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class InventoryScreen extends StatefulWidget {
  final User user;

  const InventoryScreen({super.key, required this.user});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late InventoryService _inventoryService;
  List<InventoryItem> _items = [];
  bool _sortByName = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _inventoryService = InventoryService('your_username', 'your_password', 'your_db_address');
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() => _isLoading = true);
    final items = await _inventoryService.getInventory(
      widget.user.username,
      widget.user.token ?? '',
    );
    setState(() {
      _items = items;
      _isLoading = false;
    });
    _sortItems();
  }

  void _sortItems() {
    setState(() {
      if (_sortByName) {
        _items.sort((a, b) => a.productName.compareTo(b.productName));
      } else {
        _items.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _sortByName = !_sortByName;
                _sortItems();
              });
            },
            tooltip: _sortByName ? 'Sort by expiry date' : 'Sort by name',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInventory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final daysUntilExpiry =
                    item.expiryDate.difference(DateTime.now()).inDays;
                
                return ListTile(
                  title: Text(item.productName),
                  subtitle: Text('Expires: ${item.expiryDate.toString().split(' ')[0]}'),
                  trailing: Text(
                    '$daysUntilExpiry days left',
                    style: TextStyle(
                      color: daysUntilExpiry < 7
                          ? Colors.red
                          : daysUntilExpiry < 14
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                );
              },
            ),
    );
  }
} 