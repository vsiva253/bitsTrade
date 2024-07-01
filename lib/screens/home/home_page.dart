

import 'package:flutter/material.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../subscription/subscription_screen.dart';


class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
 
  @override
  Widget build(BuildContext context) {



    return SingleChildScrollView(
    
        child: Padding(
    padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width:MediaQuery.of(context).size.width ,
                height: 153,
     
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFCCFFF2),),
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
        overflow: TextOverflow.ellipsis
      ),
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
        overflow: TextOverflow.ellipsis
      ),
            
                          ),
                           SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.arrow_drop_up,
                                  color: Color(0xFF00B386),),
                              Text(
                                '+50,18%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color:
                                            Color(0xFF00B386),)
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '₹72,000',
                            style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF44475B),
        overflow: TextOverflow.ellipsis
      ),
             
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Subscribe to the plans to start copy trading',
                style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF44475B),
        overflow: TextOverflow.ellipsis
      ),
             
              ),
              SubscriptionScreen(),
            ],
          ),
        ),
      
    );
  }
}
