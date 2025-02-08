import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';
import '../models/order.dart';
import '../models/product.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final List<Order> _orders = [
    Order(
      id: '1001',
      date: DateTime.now().subtract(const Duration(days: 1)),
      items: [
        OrderItem(
          product: Product(
            id: '1',
            name: 'Laptop Dell XPS 13',
            price: 1299.99,
            quantity: 1,
            unitVolume: 0.002,
            unitWeight: 1.2,
            type: ProductType.FRAGILE,
          ),
          quantity: 1,
        ),
        OrderItem(
          product: Product(
            id: '4',
            name: 'Sony WH-1000XM4',
            price: 349.99,
            quantity: 1,
            unitVolume: 0.001,
            unitWeight: 0.25,
            type: ProductType.COVERED,
          ),
          quantity: 2,
        ),
      ],
      status: OrderStatus.AWAITING_CONFIRMATION,
      total: 1999.97,
      supplyPhone: '+1 234-567-8901',
    ),
    Order(
      id: '1002',
      date: DateTime.now().subtract(const Duration(days: 3)),
      items: [
        OrderItem(
          product: Product(
            id: '2',
            name: 'iPhone 13 Pro',
            price: 999.99,
            quantity: 1,
            unitVolume: 0.0002,
            unitWeight: 0.2,
            type: ProductType.FRAGILE,
          ),
          quantity: 1,
        ),
      ],
      status: OrderStatus.COMPLETED,
      total: 999.99,
      supplyPhone: '+1 234-567-8902',
    ),
    Order(
      id: '1003',
      date: DateTime.now().subtract(const Duration(days: 5)),
      items: [
        OrderItem(
          product: Product(
            id: '3',
            name: 'Samsung 4K Smart TV',
            price: 799.99,
            quantity: 1,
            unitVolume: 0.15,
            unitWeight: 15.5,
            type: ProductType.FRAGILE,
          ),
          quantity: 1,
        ),
        OrderItem(
          product: Product(
            id: '5',
            name: 'iPad Air',
            price: 599.99,
            quantity: 1,
            unitVolume: 0.0008,
            unitWeight: 0.46,
            type: ProductType.FRAGILE,
          ),
          quantity: 1,
        ),
      ],
      status: OrderStatus.CANCELED,
      total: 1399.98,
      supplyPhone: '+1 234-567-8903',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
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
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
              child: Text(
                loc.get('page2'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            _orders.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: primaryColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            loc.get('no_orders'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: primaryColor.withOpacity(0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _orders.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      final cardColor = isDark ? Colors.grey[850] : Colors.white;
                      final headerColor = isDark 
                          ? primaryColor.withOpacity(0.15) 
                          : primaryColor.withOpacity(0.1);
                      final chipColor = isDark 
                          ? Colors.grey[800] 
                          : Colors.grey[100];
                      final chipBorder = isDark 
                          ? Border.all(color: Colors.grey[700]!) 
                          : null;
                      
                      Color getStatusColor(OrderStatus status) {
                        switch (status) {
                          case OrderStatus.AWAITING_CONFIRMATION:
                            return Colors.orange;
                          case OrderStatus.DELIVERING:
                            return Colors.blue;
                          case OrderStatus.COMPLETED:
                            return Colors.green;
                          case OrderStatus.CANCELED:
                            return Colors.red;
                        }
                      }

                      IconData getStatusIcon(OrderStatus status) {
                        switch (status) {
                          case OrderStatus.AWAITING_CONFIRMATION:
                            return Icons.pending;
                          case OrderStatus.DELIVERING:
                            return Icons.local_shipping;
                          case OrderStatus.COMPLETED:
                            return Icons.check_circle;
                          case OrderStatus.CANCELED:
                            return Icons.cancel;
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: isDark ? 0 : 4,
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: isDark 
                              ? BorderSide(color: Colors.grey[800]!) 
                              : BorderSide.none,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: headerColor,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDark 
                                          ? Colors.grey[900]!.withOpacity(0.5) 
                                          : Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: isDark 
                                          ? Border.all(color: Colors.grey[800]!) 
                                          : null,
                                    ),
                                    child: Text(
                                      '${loc.get('order')} #${order.id}',
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.grey[300] : primaryColor,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(order.status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: isDark 
                                          ? Border.all(color: getStatusColor(order.status).withOpacity(0.3)) 
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          getStatusIcon(order.status),
                                          size: 16,
                                          color: getStatusColor(order.status),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          loc.get(order.status.translationKey),
                                          style: TextStyle(
                                            color: getStatusColor(order.status),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: chipColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: chipBorder,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              loc.get('date'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isDark 
                                                    ? Colors.grey[400] 
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                            Text(
                                              order.date.toString().split('.')[0],
                                              style: TextStyle(
                                                color: isDark 
                                                    ? Colors.grey[300] 
                                                    : Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Text(
                                          loc.get('items'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDark 
                                                ? Colors.grey[300] 
                                                : Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...order.items.map((item) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: isDark 
                                                      ? Colors.grey[700] 
                                                      : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  _getProductTypeIcon(item.product.type),
                                                  size: 16,
                                                  color: isDark ? Colors.white : primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.product.name,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: isDark 
                                                            ? Colors.white 
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${item.quantity}x \$${item.product.price}',
                                                      style: TextStyle(
                                                        color: isDark 
                                                            ? Colors.grey[400] 
                                                            : Colors.grey[600],
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark 
                                                      ? Colors.white 
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              loc.get('total'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: isDark 
                                                    ? Colors.white 
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              '\$${order.total.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: isDark 
                                                    ? primaryColor 
                                                    : primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    loc.get('weight'),
                                                    style: TextStyle(
                                                      color: isDark 
                                                          ? Colors.grey[400] 
                                                          : Colors.grey[600],
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${order.items.fold(0.0, (sum, item) => sum + (item.product.unitWeight * item.quantity)).toStringAsFixed(2)} kg',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: isDark 
                                                          ? Colors.white 
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    loc.get('volume'),
                                                    style: TextStyle(
                                                      color: isDark 
                                                          ? Colors.grey[400] 
                                                          : Colors.grey[600],
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${order.items.fold(0.0, (sum, item) => sum + (item.product.unitVolume * item.quantity)).toStringAsFixed(4)} m³',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: isDark 
                                                          ? Colors.white 
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 16,
                                              color: isDark 
                                                  ? Colors.grey[400] 
                                                  : Colors.grey[600],
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              order.supplyPhone,
                                              style: TextStyle(
                                                color: isDark 
                                                    ? Colors.grey[300] 
                                                    : Colors.grey[800],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (order.status == OrderStatus.AWAITING_CONFIRMATION) ...[
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              final index = _orders.indexOf(order);
                                              _orders[index] = order.copyWith(
                                                status: OrderStatus.CANCELED,
                                              );
                                            });
                                          },
                                          icon: const Icon(Icons.cancel),
                                          label: Text(loc.get('cancel')),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
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