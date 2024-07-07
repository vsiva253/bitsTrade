import 'package:bits_trade/screens/billing/billing_history_screen.dart';
import 'package:bits_trade/screens/dashboard/dashboard_screen.dart';
import 'package:bits_trade/screens/home/home_page.dart';
import 'package:bits_trade/screens/profile/profile_modal.dart';
import 'package:bits_trade/screens/profile/profile_provider.dart';
import 'package:bits_trade/screens/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers/subscription_provider.dart';






class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});


  
  @override
  _BottomBarState createState() => _BottomBarState();
}
class _BottomBarState extends ConsumerState<BottomBar> {

  int _selectedIndex = 0;
  static  final List<Widget> _widgetOptions = <Widget>[
    const MyHomePage(),
    const DashboardScreen(),
    const SubscriptionHistoryScreen(),
  ];


 UserProfile? userProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(profileProvider.notifier).getCurrentUser();
   
  }

  fetchProfile()async{
userProfile =await ref.watch(profileProvider);

  }
  void _onItemTapped(int index) {
    if (_selectedIndex==2){
     
        ref.read(subscriptionHistoryProvider);
     
  

    
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // top bar color
      statusBarIconBrightness: Brightness.dark, // top bar icons
    ));
        final userProfile = ref.watch(profileProvider);
    return Scaffold(
      appBar: appbarWidget(context, userProfile.name??'.............', userProfile.avatar??''),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/bottom_bar/home.png',color: Theme.of(context).iconTheme.color,),
            activeIcon: Image.asset('assets/bottom_bar/home.png',),
            label: '',
          ),
          BottomNavigationBarItem(
          icon: Image.asset('assets/bottom_bar/transactions.png',color: Theme.of(context).iconTheme.color),
          activeIcon: Image.asset('assets/bottom_bar/transactions.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/bottom_bar/history.png',color: Theme.of(context).iconTheme.color),
                   activeIcon: Image.asset('assets/bottom_bar/history.png'),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF00B386),
        onTap: _onItemTapped,
      ),
    );
  }
}


  AppBar appbarWidget(BuildContext context, String userName, String imageUrl) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () {
          // Handle menu button press
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const SettingsScreen()));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 0.1),
            image:  DecorationImage(
              image: NetworkImage(
                imageUrl,
              ),
              fit: BoxFit.contain,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),

          // child: Image.network('https://st.depositphotos.com/1537427/3571/v/950/depositphotos_35717211-stock-illustration-vector-user-icon.jpg',)
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('Welcome',
                  style: TextStyle(
                    color: Color(0xFF00B386),
                    fontSize: 12,
                    fontWeight: FontWeight.w400
              )),
              Spacer()
            ],
          ),
          Row(
            children: [
              Text(userName, // Replace with actual name
                  style:const TextStyle(
                    color: Color(0xFF00B386),
                    fontSize: 16,
                    fontWeight: FontWeight.w500
              )),
              const Spacer()
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Handle notification icon press
          },
          icon: const Icon(
            Icons.notifications_outlined,
            size: 30,
            color: Color(0xFF00B386),
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
