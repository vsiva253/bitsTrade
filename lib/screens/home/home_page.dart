import 'package:bits_trade/screens/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/subscription_provider.dart';
import '../../widgets/subscription_card.dart';
import '../subscription/subscription_checkout_screen.dart';
import '../subscription/subscription_screen.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool isSubscriptionActive=false;
  bool isLoading =true;
  @override
  void initState() {
  SchedulerBinding.instance.addPostFrameCallback((_)async {
        bool temp =await ref.watch(subscriptionStatusProvider);
      setState(() { 
    
        isSubscriptionActive = temp;
        print('isSubscriptionActive $isSubscriptionActive');

        isLoading=false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final subscriptionAsyncValue = ref.watch(subscriptionProvider);
   

    return SingleChildScrollView(
      child:isLoading?const Center(child: CircularProgressIndicator(),) :Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
      
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 153,
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFFCCFFF2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'My portfolio',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF44475B),
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '₹45,000',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF44475B),
                              //  overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profit',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF44475B),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.arrow_drop_up,
                                color: Color(0xFF00B386),
                              ),
                              Text('+50,18%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: const Color(0xFF00B386),
                                      )),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '₹72,000',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF44475B),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
               !isSubscriptionActive?      const Text(
              'Subscribe to the plans to start copy trading',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF44475B),
                  overflow: TextOverflow.ellipsis),
            ):Container(),
   isSubscriptionActive? Container()   :  subscriptionAsyncValue.when(
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
    );
  }
}
