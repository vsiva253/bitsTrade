import 'package:bits_trade/screens/dashboard/dashboard_screen.dart';
import 'package:bits_trade/screens/subscription/subscription_checkout_provider.dart';
import 'package:bits_trade/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Add this import statement

import '../../data/modals/subscription_history_modal.dart';
import '../../data/providers/subscription_provider.dart';

class SubscriptionHistoryScreen extends ConsumerStatefulWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  _SubscriptionHistoryScreenState createState() =>
      _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState
    extends ConsumerState<SubscriptionHistoryScreen> {


    
  @override
  void initState() {
   
    // ref.read(subscriptionHistoryProvider);
    // ref.refresh(subscriptionHistoryProvider);


print(SharedPrefs.getToken());

    // ref.watch(subscriptionHistoryProvider);

    super.initState();
  }
   

  @override
  Widget build(
    BuildContext context,
  ) {
  
    final subscriptionHistory = ref.watch(subscriptionHistoryProvider);
    ref.watch(paymentStatusProvider);
    ref.listen(paymentStatusProvider, (previous, next) {
      if (next == PaymentStatus.error) {
       ref.refresh(subscriptionHistoryProvider);
       setState(() {
         
       });
      }
    });






 

    return Scaffold(
      body: subscriptionHistory.when(
        data: (history) => history!.data == null || history.data!.isEmpty
            ?const Center(
              child: Text('Something Went Wrong'),
            )
            : Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: history.data!.length,
                      itemBuilder: (context, index) {
                        final subscription = history.data![index];
                        return SubscriptionHistoryItem(
                          subscription: subscription,
                          isEven: index % 2 == 0, // Determine even or odd
                        );
                      },
                    ),
                  ),
                ],
              ),
        error: (error, stackTrace) => const Center(
          child: Text('No subscription history found.'),
        ),
        loading: () => const ParentDataShimmer(),
        
      ),
    );
  }
}

class SubscriptionHistoryItem extends StatelessWidget {
  final Datum subscription;
  final bool isEven;

  const SubscriptionHistoryItem(
      {super.key, required this.subscription, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yy-MM-dd'); // Date formatter

    return Container(
      color: isEven ? Theme.of(context).colorScheme.tertiary : Colors.white,
      // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Status, Trading, Plan, Valid days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem('Status', subscription.status ?? 'N/A'),
                _buildInfoItem('Trading', subscription.trading ?? 'N/A'),
                _buildInfoItem('Plan', subscription.plan ?? 'N/A'),
                _buildInfoItem('Valid days',
                    '${(subscription.endDate! - subscription.startDate!) ~/ (24 * 60 * 60)} days'),
              ],
            ),
            const SizedBox(height: 16),

            // Row 2: Start date, End date, Download Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                    'Start date',
                    formatter.format(DateTime.fromMillisecondsSinceEpoch(
                        subscription.startDate! * 1000))),
                _buildInfoItem(
                    'End date',
                    formatter.format(DateTime.fromMillisecondsSinceEpoch(
                        subscription.endDate! * 1000))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                  ),
                  onPressed: () {
                    // Handle download logic here
                  },
                  child: const Text('Download'),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7C7E8C),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF44475B),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
