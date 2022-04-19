import 'package:snow_remover/models/cart_model.dart';

class CheckoutArgs {
  final List<CartModel> items;
  DateTime? rDateTime;
  CheckoutArgs({required this.items, this.rDateTime});
}
