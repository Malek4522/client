import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';
import '../models/product.dart';
import '../models/order.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Laptop Dell XPS 13',
      price: 1299.99,
      quantity: 10,
      description: 'Latest model with 11th Gen Intel Core i7, 16GB RAM, 512GB SSD',
      unitVolume: 0.002,
      unitWeight: 1.2,
      type: ProductType.FRAGILE,
    ),
    Product(
      id: '2',
      name: 'iPhone 13 Pro',
      price: 999.99,
      quantity: 15,
      description: '256GB, Graphite, 5G Capable',
      unitVolume: 0.0002,
      unitWeight: 0.2,
      type: ProductType.FRAGILE,
    ),
    Product(
      id: '3',
      name: 'Samsung 4K Smart TV',
      price: 799.99,
      quantity: 5,
      description: '55-inch, HDR, Voice Control',
      unitVolume: 0.15,
      unitWeight: 15.5,
      type: ProductType.FRAGILE,
    ),
    Product(
      id: '4',
      name: 'Sony WH-1000XM4',
      price: 349.99,
      quantity: 20,
      description: 'Wireless Noise Cancelling Headphones',
      unitVolume: 0.001,
      unitWeight: 0.25,
      type: ProductType.COVERED,
    ),
    Product(
      id: '5',
      name: 'iPad Air',
      price: 599.99,
      quantity: 12,
      description: '64GB, Wi-Fi, Space Gray',
      unitVolume: 0.0008,
      unitWeight: 0.46,
      type: ProductType.FRAGILE,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  ProductType? _selectedFilterType;
  String _sortBy = 'name';
  bool _sortAscending = true;
  final TextEditingController _phoneController = TextEditingController();
  final Map<String, int> _selectedQuantities = {};

  List<Product> get _filteredAndSortedProducts {
    List<Product> result = List.from(_products);
    
    // Apply search
    if (_searchController.text.isNotEmpty) {
      result = result.where((product) =>
        product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        product.id.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        product.description.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    // Apply type filter
    if (_selectedFilterType != null) {
      result = result.where((product) => product.type == _selectedFilterType).toList();
    }
    
    // Apply sorting
    result.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
        case 'quantity':
          comparison = a.quantity.compareTo(b.quantity);
          break;
        default:
          comparison = 0;
      }
      return _sortAscending ? comparison : -comparison;
    });
    
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    final loc = AppLocalizations.of(context);
    if (_selectedQuantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.get('select_items_first')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.get('order_summary')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...(_selectedQuantities.entries.map((entry) {
                final product = _products.firstWhere((p) => p.id == entry.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text('${entry.value}x \$${product.price}'),
                    ],
                  ),
                );
              })),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.get('total'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_calculateTotal().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.get('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                // Create order items
                final orderItems = _selectedQuantities.entries.map((entry) {
                  final product = _products.firstWhere((p) => p.id == entry.key);
                  return OrderItem(
                    product: product,
                    quantity: entry.value,
                  );
                }).toList();

                // Create the order
                final order = Order(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: DateTime.now(),
                  items: orderItems,
                  status: OrderStatus.AWAITING_CONFIRMATION,
                  total: _calculateTotal(),
                  supplyPhone: '', // Empty since auth handles user info
                );

                // Clear selections
                setState(() {
                  _selectedQuantities.clear();
                });

                Navigator.pop(context);

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.get('order_placed')),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(loc.get('place_order')),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotal() {
    return _selectedQuantities.entries.fold(0.0, (total, entry) {
      final product = _products.firstWhere((p) => p.id == entry.key);
      return total + (product.price * entry.value);
    });
  }

  Widget _buildHeader(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Text(
              loc.get('page1'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: loc.get('search'),
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => setState(() {}),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<ProductType?>(
                    value: _selectedFilterType,
                    hint: Text(
                      loc.get('filter_by_type'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                    dropdownColor: Theme.of(context).primaryColor,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          loc.get('all_types'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      ...ProductType.values.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          loc.get(type.translationKey),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                    ],
                    onChanged: (value) => setState(() => _selectedFilterType = value),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: _sortBy,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                        dropdownColor: Theme.of(context).primaryColor,
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: 'name',
                            child: Text(
                              loc.get('sort_by_name'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'price',
                            child: Text(
                              loc.get('sort_by_price'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'quantity',
                            child: Text(
                              loc.get('sort_by_quantity'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sortBy = value);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _sortAscending = !_sortAscending),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final filteredProducts = _filteredAndSortedProducts;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _products.isEmpty
                              ? loc.get('no_products')
                              : loc.get('no_matching_products'),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: primaryColor.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductCard(product, loc);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _selectedQuantities.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _placeOrder,
              icon: const Icon(Icons.shopping_cart_checkout),
              label: Text(loc.get('place_order')),
            )
          : null,
    );
  }

  Widget _buildProductCard(Product product, AppLocalizations loc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Card(
      elevation: isDark ? 0 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDark 
            ? BorderSide(color: Colors.grey[800]!) 
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image Placeholder
            AspectRatio(
              aspectRatio: 1.2,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(
                    _getProductTypeIcon(product.type),
                    size: 48,
                    color: isDark ? Colors.grey[700] : Colors.grey[400],
                  ),
                ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark 
                            ? Colors.greenAccent[400]
                            : primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Product Image
              Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    _getProductTypeIcon(product.type),
                    size: 64,
                    color: isDark ? Colors.grey[700] : Colors.grey[400],
                  ),
                ),
              ),
              // Product Info
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[850] : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: isDark 
                                      ? Border.all(color: Colors.grey[700]!) 
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getProductTypeIcon(product.type),
                                      size: 16,
                                      color: isDark ? Colors.grey[300] : primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      loc.get(product.type.translationKey),
                                      style: TextStyle(
                                        color: isDark ? Colors.grey[300] : primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isDark 
                                          ? Colors.greenAccent[400]
                                          : primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (product.description.isNotEmpty) ...[
                        Text(
                          loc.get('description'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Specifications
                      Text(
                        loc.get('specifications'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: isDark 
                              ? Border.all(color: Colors.grey[800]!) 
                              : null,
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow(
                              loc.get('weight'),
                              '${product.unitWeight} kg',
                              Icons.scale,
                              isDark,
                            ),
                            const Divider(),
                            _buildSpecRow(
                              loc.get('volume'),
                              '${product.unitVolume} m³',
                              Icons.straighten,
                              isDark,
                            ),
                            const Divider(),
                            _buildSpecRow(
                              loc.get('quantity'),
                              product.quantity.toString(),
                              Icons.inventory_2,
                              isDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Add to Cart Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: isDark 
                            ? Border.all(color: Colors.grey[700]!) 
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              final currentQty = _selectedQuantities[product.id] ?? 0;
                              if (currentQty > 0) {
                                setState(() {
                                  _selectedQuantities[product.id] = currentQty - 1;
                                  if (_selectedQuantities[product.id] == 0) {
                                    _selectedQuantities.remove(product.id);
                                  }
                                });
                                setModalState(() {});
                              }
                            },
                            style: IconButton.styleFrom(
                              foregroundColor: isDark ? Colors.grey[300] : primaryColor,
                            ),
                          ),
                          Text(
                            '${_selectedQuantities[product.id] ?? 0}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final currentQty = _selectedQuantities[product.id] ?? 0;
                              if (currentQty < product.quantity) {
                                setState(() {
                                  _selectedQuantities[product.id] = currentQty + 1;
                                });
                                setModalState(() {});
                              }
                            },
                            style: IconButton.styleFrom(
                              foregroundColor: isDark ? Colors.grey[300] : primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (_selectedQuantities[product.id] != null) {
                            _placeOrder();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _selectedQuantities[product.id] != null
                              ? loc.get('place_order')
                              : loc.get('add_to_cart'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProductTypeIcon(ProductType type) {
    switch (type) {
      case ProductType.COLD:
        return Icons.ac_unit;
      case ProductType.COVERED:
        return Icons.inventory;
      case ProductType.FRAGILE:
        return Icons.warning;
      case ProductType.LIQUID:
        return Icons.water_drop;
      case ProductType.FLAMBLE:
        return Icons.local_fire_department;
    }
  }
} 