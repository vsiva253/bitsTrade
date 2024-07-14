import 'package:bits_trade/screens/bottombar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/subscription_provider.dart';
import 'subscription_checkout_provider.dart';
import '../../widgets/subscription_card.dart';

class SubsciptionCheckoutScreen extends ConsumerWidget {
  final String subscriptionPlan;
  final int price;
  final int childCount;
   final VoidCallback? onPaymentSuccess; // Add a callback

  const SubsciptionCheckoutScreen(
    this.subscriptionPlan,
    this.price,
    this.childCount, {
    super.key,
    this.onPaymentSuccess, // Accept the callback
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final paymentStatus = ref.watch(paymentStatusProvider);
    final paymentNotifier = ref.read(paymentStatusProvider.notifier);


    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
      Navigator.pushReplacement(

                      context,
                      CupertinoPageRoute(
                        builder: (context) => BottomBar(),
                      ),
                    );
          },
        ),
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You Have Been Selected $subscriptionPlan Plan',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              // SizedBox(height: 10,),

              SubscriptionCard(
                subscriptionType: subscriptionPlan,
                subscriptionPrice: price,
                childCount: childCount,
                onTap: () {
                  // Handle subscription purchase logic here
                },
              ),

              const SizedBox(height: 20),
              Text(
                'Confirm the details to purchase!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Please Enter Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Please Enter Your Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
               
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Please Enter Your Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
               
              ),
              const SizedBox(height: 50),
              Center(
                child: (() {
                  switch (paymentStatus) {
                    case PaymentStatus.initial:
                      return Container(
                        height: 60,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: ElevatedButton(
                          onPressed: () async {
                        
                            if (formKey.currentState!.validate()) {
                              paymentNotifier.startPayment(
                            {
                              'name': nameController.text,
                              'email': emailController.text,
                              'phone': phoneController.text,
                              'country': 'india',
                              'subscription':{
                                'plan': subscriptionPlan,
                                'price': price,
                                'type': 'monthly',
                                'trading':'Copy'
                              }
                            }
                              );
                                            
                        
                                    
                            
                                ref.read(subscriptionHistoryProvider);
                           
                              ref.refresh(subscriptionHistoryProvider);
                        
                           
                            }
                                       
                          },
                          child: Text('Pay Rs.$price'),
                        ),
                      );
                    case PaymentStatus.loading:
                      return const CircularProgressIndicator();
                    case PaymentStatus.success:

                      // Call the callback when payment is successful
                      //navigate to home page
                   

           
      
                      return const Text('Payment Successful!');
                    default:
                
                      return const Text('Payment Failed!');
                  }
                })(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}