class CartModel {
  int hours;
  final String id;
  final String image;
  final String name;
  final double price;
  int quantity;
  final String type;

  CartModel({
    required this.hours,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    required this.type,
  });
}
