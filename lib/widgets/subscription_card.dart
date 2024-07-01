// lib/widgets/subscription_card.dart
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String subscriptionType;
  final int subscriptionPrice;
  final int childCount;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.subscriptionType,
    required this.subscriptionPrice,
    required this.childCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context).primaryColor,
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFF039D76),
            Color(0xFF00B386),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscriptionType,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            const Shadow(
                              color: Colors.white,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '1 parent + $childCount child',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            const Shadow(
                              color: Colors.white,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '₹$subscriptionPrice/Month',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          color: Colors.white,
                          blurRadius: 2,
                        ),
                      ],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                child: Text(
                  'Buy Now',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
