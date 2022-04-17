import 'package:snow_remover/models/order_item_model.dart';

class AdminOrderModel {
  final List<OrderItem> items;
  final DateTime orderDate;
  final bool payment;
  final DateTime reservationDatetime;
  final double total;
  final String userId;
  final String address;
  final String feedback;

  AdminOrderModel(
      this.items,
      this.orderDate,
      this.payment,
      this.reservationDatetime,
      this.total,
      this.userId,
      this.address,
      this.feedback);
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((e) => e.toMap()).toList(),
      'order_date': orderDate,
      'payment': payment,
      'reservation_datetime': reservationDatetime,
      'total': total,
      'userId': userId,
      'address': address,
      'feedback': '',
      'isDelivered':
          orderDate.compareTo(reservationDatetime) == 0 ? true : false
    };
  }
}
