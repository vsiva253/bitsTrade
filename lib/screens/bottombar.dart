import 'dart:convert';
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
import 'package:http/http.dart' as http;
import '../data/providers/subscription_provider.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';
import '../widgets/custom_toast.dart';
import 'subscription/subscription_checkout_provider.dart';

// Create a provider for subscription status
final subscriptionStatusProvider = StateProvider<bool>((ref) => false); 
class BottomBar extends ConsumerStatefulWidget {
  final int? index;
  const BottomBar({super.key, this.index});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  int? _selectedIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      _selectedIndex = widget.index;
      _isLoading = false;
    } else {
      _fetchSubscriptionStatus();
    }
    ref.read(profileProvider.notifier).getCurrentUser();
  }

  Future<void> _fetchSubscriptionStatus() async {
    var token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/api/v1/subscription/history'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data.containsKey('data') && data['data'] is List) {
        bool isActive = data['data'].any((sub) => sub['status'] == 'active');

        ref.read(subscriptionStatusProvider.notifier).state = isActive;

        setState(() {
          _selectedIndex = isActive ? 1 : 0;
          _isLoading = false;
        });

        if (isActive) {
          print('Subscription is active');
        } else {
          print('No active subscription found');
        }
      } else {
        setState(() {
          _selectedIndex = 0;
          _isLoading = false;
          ref.read(subscriptionStatusProvider.notifier).state = false;
        });
        print('No subscription data found');
        showToast('No subscription data found');
      }
    } else {
      showToast('Failed to load subscription history');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected index: $_selectedIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(profileProvider);
    final isSubscriptionActive = ref.watch(subscriptionStatusProvider);
    final paymentStatus = ref.watch(paymentStatusProvider);

    if (paymentStatus == PaymentStatus.success) {
      _fetchSubscriptionStatus();
      ref.read(paymentStatusProvider.notifier).state = PaymentStatus.initial;
      ref.read(subscriptionHistoryProvider);

      setState(() {});
    }

    return Scaffold(
      appBar: appbarWidget(context, userProfile.name ?? '.............',
          userProfile.avatar ?? 'https://via.placeholder.com/150'),
      body: _isLoading
          ? Column(
              children: [
                ...List.generate(2, (index) => const ParentDataShimmer()),
                ...List.generate(4, (_) => const ChildDataShimmer())
              ],
            )
          : IndexedStack(
              index: _selectedIndex ?? 0,
              children: [
                Consumer(builder: (context, watch, child) {
                  return const MyHomePage();
                }),
                Consumer(builder: (context, watch, child) {
                  return const DashboardScreen();
                }),
                Consumer(builder: (context, watch, child) {
                  return const SubscriptionHistoryScreen();
                }),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/bottom_bar/home.png',
              color: Theme.of(context).iconTheme.color,
            ),
            activeIcon: Image.asset(
              'assets/bottom_bar/home.png',
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/bottom_bar/transactions.png',
                color: Theme.of(context).iconTheme.color),
            activeIcon: Image.asset('assets/bottom_bar/transactions.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/bottom_bar/history.png',
                color: Theme.of(context).iconTheme.color),
            activeIcon: Image.asset('assets/bottom_bar/history.png'),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex ?? 0,
        selectedItemColor: const Color(0xFF00B386),
        onTap: _onItemTapped,
      ),
    );
  }
}

AppBar appbarWidget(BuildContext context, String userName, String imageUrl) {
  return AppBar(
    toolbarHeight: 70,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    elevation: 0,
    leading: GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const SettingsScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.black, width: 0.1),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.contain,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Welcome',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
            Spacer()
          ],
        ),
        Row(
          children: [
            Text(
              userName.toUpperCase(),
              style: const TextStyle(
              color: Color.fromARGB(221, 28, 7, 7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
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
