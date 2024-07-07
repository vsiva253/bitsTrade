import 'package:bits_trade/utils/shared_prefs.dart';
import 'package:bits_trade/widgets/custom_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../screens/subscription/subscription_details_modal.dart';

import '../../utils/constants.dart';
import '../modals/subscription_history_modal.dart';

final subscriptionProvider = FutureProvider<List<Subscription>>((ref) async {
  final response = await http.get(
    Uri.parse('${Constants.apiBaseUrl}/api/v1/public/subscriptions'),
    headers: {'accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    print(response.body);
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => Subscription.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load subscriptions');
  }
});
final selectedSubscriptionProvider = StateProvider<Subscription?>(
  (ref) => null, // Initial value is null
);


final apiEndpoint = Uri.parse('${Constants.apiBaseUrl}/api/v1/subscription/history');

// Create a Riverpod provider for fetching subscription history
final subscriptionHistoryProvider = FutureProvider<SubscriptionHistory?>((ref) async {
  print('fetching subscription history');
  var token = await SharedPrefs.getToken();
  // Fetch subscription history data using the provided API token
  final response = await http.get(
    apiEndpoint,
    headers: {
      'accept': 'application/json',
      'Authorization':
          'Bearer $token', // Replace with your actual API token
    },
  );

  // Decode the response body and return the SubscriptionHistory object
  if (response.statusCode == 200) {
    return SubscriptionHistory.fromJson(jsonDecode(response.body));
  } else {
    // Handle errors
    showToast('Failed to load subscription history');
    return null;
  }
});