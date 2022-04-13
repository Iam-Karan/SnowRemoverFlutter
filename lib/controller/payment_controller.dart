import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  Future<Map<String, dynamic>?> makePayment(
      {required String amount, required String currency}) async {
    try {
      // print("inside payment contorller");
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          testEnv: true,
          merchantCountryCode: 'CA',
          merchantDisplayName: 'Snow remover',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        Map<String, dynamic>? response = await displayPaymentSheet();
        if (response!["success"] == true) {
          return {"error": null, "success": true};
        } else {
          return {"error": response["error"], "success": false};
        }
      }
    } catch (e, s) {
      print('exception:$e$s');
      return {"error": 'exception:$e$s', "success": false};
    }
    return {"error": "payment intent data was null", "success": false};
  }

  Future<Map<String, dynamic>?> displayPaymentSheet() async {
    try {
      // print("inside display sheet");
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar('Payment', 'Payment Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 1));
      return {"error": null, "success": true};
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
      return {"error": 'exception:$e', "success": false};
    } catch (e) {
      print("exception:$e");
      return {"error": 'exception:$e', "success": false};
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51KnTwUEeWLLzf6XRkIcLGeU3HdIc8NB2VdRbFbzT2TZvOylvdeMjgFasmnlyDlPPt26cduvAf9zqmsZXwufJkrZn00Pk94nVbP',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
