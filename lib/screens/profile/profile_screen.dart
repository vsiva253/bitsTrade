import 'package:bits_trade/screens/bottombar.dart';
import 'package:bits_trade/screens/subscription/subscription_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../login/login_provider.dart';
import '../login/start_screen.dart';
import 'profile_provider.dart';
import 'profile_update_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    final userProfile = ref.watch(profileProvider);
  
     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // top bar color
      statusBarIconBrightness: Brightness.dark, // top bar icons
    ));


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Profile', style: Theme.of(context).textTheme.displayLarge),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0, // Remove shadow
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                   CircleAvatar(
                  
                    
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      
                 
                     '${userProfile.avatar}',
                    
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Text(
                        userProfile.name ?? 'Jagan Mohan Reddy',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  Column(
                    children: [
                      Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => ProfileUpdateScreen(
                              userProfile: userProfile,
                              onUpdate: (updatedProfile) {
                                ref
                                    .read(profileProvider.notifier)
                                    .updateUserProfile(updatedProfile);
                                Navigator.of(context).pop();
                              },
                            ),),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      // horizontal: 5,
                      vertical: 5,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  child:const Icon(Icons.edit),
                ),
              ),
           
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),
              // subscriptionCard(subscriprtionType: 'Basic Plan', subscriptionPrice: '1000', childCount: '1', ontap: (){},
                
              // ),
              const SizedBox(height: 20),
              buildSettingItem('Subscriptions', Icons.subscriptions, context,0),
              buildSettingItem('Billings', Icons.payment, context,1),
              buildSettingItem('General Info', Icons.info, context,2),
              buildSettingItem('Customer Support', Icons.support_agent, context,3),
              const Spacer(),
              // Edit Profile Button
            
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await ref.read(loginProvider.notifier).logout();
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => const StartScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  child: const Text('Log Out'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingItem(String title, IconData icon, BuildContext context , int index) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {

          if (index==0){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=>SubscriptionScreen()));
          }
          if(index==1){
           Navigator.push(context, CupertinoPageRoute(builder: (context) => const BottomBar(index: 2,)));

          }

          if(index==2){

          }
          if(index==3){}
            // Handle setting item tap
            // You can use the settingsNotifier here if needed
            // settingsNotifier.showSettingDialog(context, title); // Example
          },
        ),
        const Divider()
      ],
    );
  }
}
