// // lib/screens/subscription/subscription_screen.dart
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'subscription_checkout_screen.dart';
// import 'subscription_details_modal.dart';
// import '../../data/providers/subscription_provider.dart';
// import '../../widgets/subscription_card.dart';
import 'package:shimmer/shimmer.dart';


// class SubscriptionScreen extends ConsumerWidget {
//    SubscriptionScreen({super.key});
//   final selectedSubscriptionProvider = StateProvider<Subscription?>(
//   (ref) => null, // Initial value is null
// );

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
  

//     return 
 
//   }
// }
// //create shimmer widget

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Shimmer.fromColors(
            highlightColor:const Color(0xFFECFFFA).withOpacity(0.5),
          baseColor  : const Color(0xFFCCFFF2).withOpacity(0.5),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
