import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final User user;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.user,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late InventoryService _inventoryService;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));
  String _notes = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _inventoryService = InventoryService('your_username', 'your_password', 'your_db_address');
  }

  Future<void> _addToInventory() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final item = InventoryItem(
        barcode: widget.product.barcode,
        productName: widget.product.name,
        expiryDate: _expiryDate,
        notes: _notes,
        addedDate: DateTime.now(),
      );

      final success = await _inventoryService.addItem(
        widget.user.username,
        widget.user.token ?? '',
        item,
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to inventory')),
        );
        Navigator.pop(context);
        Navigator.pop(context); // Return to scanner
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add product')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Back to Scanner',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Brand: ${widget.product.brand}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Text(
                'Set Expiry Date:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _expiryDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (picked != null) {
                    setState(() => _expiryDate = picked);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '${_expiryDate.year}-${_expiryDate.month.toString().padLeft(2, '0')}-${_expiryDate.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => _notes = value,
              ),
              const SizedBox(height: 24),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _addToInventory,
                        child: const Text('Add to Inventory'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 