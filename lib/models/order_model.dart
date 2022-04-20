import 'package:snow_remover/models/order_item_model.dart';

class OrderModel {
  final List<OrderItem> items;
  final DateTime orderDate;
  final bool payment;
  final DateTime reservationDatetime;
  final double total;
  final String address;

  OrderModel(this.items, this.orderDate, this.payment, this.reservationDatetime,
      this.total, this.address);
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((e) => e.toMap()).toList(),
      'order_date': orderDate,
      'payment': payment,
      'reservation_datetime': reservationDatetime,
      'total': total,
      'address': address
    };
  }
}
