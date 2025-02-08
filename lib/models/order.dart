import 'product.dart';

enum OrderStatus {
  AWAITING_CONFIRMATION('status_awaiting_confirmation'),
  DELIVERING('status_delivering'),
  COMPLETED('status_completed'),
  CANCELED('status_canceled');

  final String translationKey;
  const OrderStatus(this.translationKey);
}

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final OrderStatus status;
  final double total;
  final String supplyPhone;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.status,
    required this.total,
    required this.supplyPhone,
  });

  Order copyWith({
    String? id,
    DateTime? date,
    List<OrderItem>? items,
    OrderStatus? status,
    double? total,
    String? supplyPhone,
  }) {
    return Order(
      id: id ?? this.id,
      date: date ?? this.date,
      items: items ?? this.items,
      status: status ?? this.status,
      total: total ?? this.total,
      supplyPhone: supplyPhone ?? this.supplyPhone,
    );
  }
} 