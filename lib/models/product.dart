enum ProductType {
  COLD('type_cold'),
  COVERED('type_covered'),
  FRAGILE('type_fragile'),
  LIQUID('type_liquid'),
  FLAMBLE('type_flamble');

  final String translationKey;
  const ProductType(this.translationKey);
}

class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final double unitVolume; // in cubic meters (m³)
  final double unitWeight; // in kilograms (kg)
  final ProductType type;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.description = '',
    required this.unitVolume,
    required this.unitWeight,
    required this.type,
  });
} 