class OrderItem {
  final String hour;
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  final String quantity;
  final String type;
  OrderItem(this.hour, this.id, this.imageUrl, this.name, this.price,
      this.quantity, this.type);
  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'quantity': quantity,
      'type': type
    };
  }
}
