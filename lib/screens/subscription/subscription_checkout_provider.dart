
// State provider for checkout details
import 'package:bits_trade/utils/shared_prefs.dart';
import 'package:bits_trade/widgets/custom_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../../utils/constants.dart';





// State provider for payment status
final paymentStatusProvider = StateNotifierProvider<PaymentStatusNotifier, PaymentStatus>(
  (ref) => PaymentStatusNotifier(),
);

class PaymentStatusNotifier extends StateNotifier<PaymentStatus> {
  PaymentStatusNotifier() : super(PaymentStatus.initial);

  Future<void> startPayment(Map<String, dynamic> checkoutDetails) async {
   

  final apiEndpoint = Uri.parse('${Constants.apiBaseUrl}/api/v1/subscription/add');
// Replace with your actual API key

  // Sample data for the request body 
  final body = checkoutDetails;
  var token=await SharedPrefs.getToken();
state = PaymentStatus.loading;
  final response = await http.post(
    apiEndpoint,
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    showToast('Payment successful');
    state = PaymentStatus.success;
    state = PaymentStatus.initial;




    
  } else {
    state = PaymentStatus.error;
    state=PaymentStatus.initial;
    showToast('Payment failed');
  
  }
}

  }

enum PaymentStatus { initial, loading, success, error }