// // lib/screens/subscription/subscription_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subscription_checkout_screen.dart';
import 'subscription_details_modal.dart';
import '../../data/providers/subscription_provider.dart';
import '../../widgets/subscription_card.dart';
import 'package:shimmer/shimmer.dart';


class SubscriptionScreen extends ConsumerWidget {
   SubscriptionScreen({super.key});
  final selectedSubscriptionProvider = StateProvider<Subscription?>(
  (ref) => null, // Initial value is null
);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsyncValue = ref.watch(subscriptionProvider);
  

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions', style: TextStyle(
          color:Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600
        )),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back,)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose a Subscription Plan', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 10),
              subscriptionAsyncValue.when(
                  data: (subscriptions) {
                    return  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: subscriptions.length,
                      itemBuilder: (context, index) {
                        final subscription = subscriptions[index];
                        return SubscriptionCard(
                          subscriptionType: subscription.plan,
                          subscriptionPrice: subscription.price,
                          childCount: subscription.child,
                          onTap: () {
                           
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  SubsciptionCheckoutScreen(
                            subscription.plan,
                            subscription.price,
                            subscription.child
              
                              ),
                            ),
                          );
              
                            // Handle the subscription purchase logic here
                          },
                        );
                      },
                    );
                  },
                  loading: () => const ShimmerWidget(),
                  error: (error, stackTrace) => Center(child: Text('Error: $error')),
               
              ),
            ],
          ),
        ),
      ),
    );
 
  }
}
//create shimmer widget

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
